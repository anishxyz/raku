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
    
    func refresh(for project: Project, startDate: Date? = nil, endDate: Date? = nil) {
        let trueStartDate = startDate ?? Calendar.current.date(byAdding: .month, value: -6, to: Date())!
        let trueEndDate = endDate ?? Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        
        switch project.type {
        case .github:
            self._fetchAndMergeGithubContributions(
                for: project,
                startDate: trueStartDate,
                endDate: trueEndDate
            )
            
        case .binary:
            self._createBlankCommits(for: project, startDate: trueStartDate, endDate: trueEndDate)
            
        case _:
           // Handle any other cases
           return
        }
    }
    
    private func _createBlankCommits(for project: Project, startDate: Date, endDate: Date) {
        let days = generateRakuDates(from: startDate, to: endDate)
        
        let existingDict: [RakuDate: Commit]  = Dictionary(
            uniqueKeysWithValues: project.commits.map { ($0.date, $0) }
        )
        var newDict: [RakuDate: Commit] = [:]
        
        for day in days {
            if existingDict[day] == nil {
                let commit = Commit(date: day, intensity: 0, project: project)
                commit.project = project
                modelContext.insert(commit)
                newDict[day] = commit
            }
        }
        
        if !newDict.isEmpty {
            do {
                try modelContext.save()
            } catch {
                print("Failed to save commits: \(error)")
            }
        }
    }
    
    private func _fetchAndMergeGithubContributions(
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
