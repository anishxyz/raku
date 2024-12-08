//
//  MockData.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftData


// Extension to generate a random date within the last year
extension Date {
    static func randomDateInLastYear() -> Date {
        let day = arc4random_uniform(365) + 1
        let hour = arc4random_uniform(24)
        let minute = arc4random_uniform(60)
        let second = arc4random_uniform(60)
        return Calendar.current.date(byAdding: .day, value: -Int(day), to: Date())!
            .addingTimeInterval(TimeInterval(hour * 3600 + minute * 60 + second))
    }
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Project.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let projectNames = ["Orion", "Nova", "Quasar"]
        let projectTypes: [ProjectType] = [.github, .range, .binary]
        
        for i in 0..<3 {
            let newProject = Project(
                created_at: Date.randomDateInLastYear(),
                type: projectTypes[i],
                name: projectNames[i]
            )
            container.mainContext.insert(newProject)
            
            for _ in 1...10 {
                let commit = Commit(
                    timestamp: Date.randomDateInLastYear(),
                    intensity: Float.random(in: 0...1),
                    project: newProject
                )
                container.mainContext.insert(commit)
//                newProject.commits.append(commit)
            }
        }

        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
