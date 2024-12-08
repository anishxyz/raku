//
//  MockData.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftData


// MARK: - Constants for preview data generation
private let numberOfProjects = 4
private let numberOfCommitsPerProject = 10
private let numberOfProjectsInLastWeek = 1 // How many should start in last week

// Sample arrays - for demonstration, assume you have enough project names/types
private let projectNames = ["Orion", "Nova", "Quasar"]
private let projectTypes: [ProjectType] = [.github, .range, .binary]

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Project.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        // Decide which projects are recent (in last week) and which are older (in last year)
        let recentProjectsCount = min(numberOfProjectsInLastWeek, numberOfProjects)
        let olderProjectsCount = numberOfProjects - recentProjectsCount

        // Create projects that start in the last week
        for i in 0..<recentProjectsCount {
            let newProject = Project(
                created_at: Date.randomDateInLastWeek(),
                type: projectTypes[i % projectTypes.count],
                name: projectNames[i % projectNames.count]
            )
            container.mainContext.insert(newProject)

            // Add commits
            for _ in 1...numberOfCommitsPerProject {
                let commit = Commit(
                    date: Date.randomDateInLastWeek(),
                    intensity: Float.random(in: 0...1),
                    project: newProject
                )
                container.mainContext.insert(commit)
            }
        }

        // Create projects that start in the last year
        for i in recentProjectsCount..<recentProjectsCount + olderProjectsCount {
            let newProject = Project(
                created_at: Date.randomDateInLastYear(),
                type: projectTypes[i % projectTypes.count],
                name: projectNames[i % projectNames.count]
            )
            container.mainContext.insert(newProject)

            // Add commits
            for _ in 1...numberOfCommitsPerProject {
                let commit = Commit(
                    date: Date.randomDateInLastYear(),
                    intensity: Float.random(in: 0...1),
                    project: newProject
                )
                container.mainContext.insert(commit)
            }
        }

        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()

