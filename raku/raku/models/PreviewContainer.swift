//
//  MockData.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftData


@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Project.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        // Fixed dates for demonstration
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
        
        // Create two projects started about a year ago with 20 commits each
        let projectA = Project(
            created_at: oneYearAgo,
            type: .binary,
            name: "Project Haiku",
            key: nil
        )
        container.mainContext.insert(projectA)
        
        for i in 1...20 {
            let commit = Commit(
                date: oneYearAgo.addingTimeInterval(Double(i) * 3600),
                intensity: Float(i) / 20.0,
                project: projectA
            )
            container.mainContext.insert(commit)
        }

        let projectB = Project(
            created_at: oneYearAgo,
            type: .binary,
            name: "Project Sonnet",
            key: nil
        )
        container.mainContext.insert(projectB)
        
        for i in 1...20 {
            let commit = Commit(
                date: oneYearAgo.addingTimeInterval(Double(i) * 3600),
                intensity: Float(i) / 20.0,
                project: projectB
            )
            container.mainContext.insert(commit)
        }

        // Create one project started in the last week with 4 commits
        let projectC = Project(
            created_at: oneWeekAgo,
            type: .binary,
            name: "Project Opus",
            key: nil
        )
        container.mainContext.insert(projectC)
        
        for i in 1...4 {
            let commit = Commit(
                date: oneWeekAgo.addingTimeInterval(Double(i) * 86400),
                intensity: Float(i) / 4.0,
                project: projectC
            )
            container.mainContext.insert(commit)
        }

        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()

