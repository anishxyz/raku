//
//  PreviewContainer.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftData
import SwiftUI

var BINARY_PROJECT_NAMES = ["Haiku", "Sonnet", "Opus"]

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Project.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let projectColors = RakuColorList

        for color in projectColors {
            let project = Project(
                name: "anishxyz",
                type: .github,
                color: color,
                created_at: Date()
            )
            container.mainContext.insert(project)
        }

        
        let project = Project(
            name: "anishxyz",
            type: .github,
            color: RakuColors.githubGreen,
            created_at: Date()
        )
        container.mainContext.insert(project)
        

        // Fixed reference dates
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()

        // Start dates for each project
        let startDates = [oneYearAgo, oneMonthAgo, oneWeekAgo]

        // Commits per project
        let commitCounts = [100, 20, 4]

        // Define the pattern for commits: X on-days, then Y off-days, and repeat
        let patternOnDays = 3   // Number of consecutive days with commits
        let patternOffDays = 2  // Number of consecutive days without commits
        let patternLength = patternOnDays + patternOffDays

        // Iterate over project names and create each project with patterned commits
        for (index, projectName) in BINARY_PROJECT_NAMES.enumerated() {
            let startDate = startDates[index]
            let numberOfCommits = commitCounts[index]

            let project = Project(
                name: "Project \(projectName)",
                type: .binary,
                color: Color.blue,
                created_at: startDate
            )
            container.mainContext.insert(project)

            // Add commits following the pattern starting from the project's start date
            for dayOffset in 0..<numberOfCommits {
                // Determine if this day is an "on" day or an "off" day
                let patternPosition = dayOffset % patternLength
                let isCommitDay = patternPosition < patternOnDays

                // Calculate the date for this offset
                let commitDate = Date().addingTimeInterval(Double(-dayOffset) * 86400)

                // Insert a commit only on an "on" day
                if isCommitDay {
                    let commit = Commit(
                        date: commitDate,
                        intensity: 1,
                        project: project
                    )
                    container.mainContext.insert(commit)
                }
            }
        }

        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
