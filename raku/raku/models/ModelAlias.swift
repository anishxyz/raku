//
//  ModelAlias.swift
//  raku
//
//  Created by Anish Agrawal on 12/24/24.
//

import Foundation
import SwiftData

typealias Commit = GraphSchemaV1.Commit
typealias Project = GraphSchemaV1.Project
typealias ProjectType = GraphSchemaV1.ProjectType

public extension Project {
    static let schema = SwiftData.Schema([
        Project.self,
        Commit.self
    ])
    
    static let container: ModelContainer = {
        let groupID = "group.xyz.anish.raku"
        let modelConfiguration = ModelConfiguration(groupContainer: .identifier(groupID))
        
        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    func refresh(modelContext: ModelContext, startDate: Date? = nil, endDate: Date? = nil) {
        switch type {
        case .github:
            // refresh github contributions
            self._fetchAndMergeGithubContributions(
                for: self,
                 modelContext: modelContext,
                 startDate: startDate,
                 endDate: endDate
            )
            
        case .binary:
            // Binary projects don't need refreshing
            return
            
        case _:
           // Handle any other cases
           return
        }
    }
    
    
    private func _fetchAndMergeGithubContributions(
        for project: Project,
        modelContext: ModelContext,
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
                            modelContext.insert(newCommit)
                        }
                    }
                    
                    try? modelContext.save()
                }
                
            case .failure(let error):
                print("Failed to fetch contributions: \(error)")
            }
        }
    }
    
}

