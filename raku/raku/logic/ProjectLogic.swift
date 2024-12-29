//
//  ProjectLogic.swift
//  raku
//
//  Created by Anish Agrawal on 12/24/24.
//

import SwiftData
import Foundation
import SwiftUI


struct ProjectLogic {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func createProject(name: String, type: ProjectType, color: Color) -> Project {
        let new_project = Project(name: name, type: type, color: color)
        self.modelContext.insert(new_project)
        try? self.modelContext.save()
        
        return new_project
    }
    
    func updateProject(project: Project, name: String?, color: Color?) -> Project {
        if let name = name {
            project.name = name
        }
        
        if let color = color {
            project._color = extractColorComponents(from: color)
        }
        
        try? self.modelContext.save()
        
        return project
    }
    
    func archiveProject(project: Project) {
        project.archived_at = Date()
        
        try? self.modelContext.save()
    }
    
    func fetchAndMergeGithubContributions(
        for project: Project,
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        let username = project.name
        
        let existingCommits: [RakuDate: Commit] = Dictionary(
            uniqueKeysWithValues: project.commits
                .filter { commit in
                    if let start = startDate, let end = endDate {
                        let srd = RakuDate(date: start)
                        let erd = RakuDate(date: end)
                        return commit.date >= srd && commit.date <= erd
                    }
                    return true
                }
                .map { ($0.date, $0) }
        )
        
        RakuAPIManager.shared.fetchContributions(
            for: username,
            startDate: startDate,
            endDate: endDate
        ) { result in
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let newContributions = Dictionary(
                        uniqueKeysWithValues: response.contributions.map { ($0.date, $0.count) }
                    )
                    // overwrite
                    for (date, count) in newContributions {
                        let rd = RakuDate(date: date)
                        
                        if let existingCommit = existingCommits[rd] {
                            // Update existing commit
                            existingCommit.intensity = count
                        } else {
                            // Create new commit
                            let newCommit = Commit(date: date, intensity: count, project: project)
                            self.modelContext.insert(newCommit)
                        }
                    }
                    
                    try? self.modelContext.save()
                }
                
            case .failure(let error):
                print("Failed to fetch contributions: \(error)")
            }
        }
    }
}
