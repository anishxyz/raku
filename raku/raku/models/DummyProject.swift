//
//  DummyProject.swift
//  raku
//
//  Created by Anish Agrawal on 1/20/25.
//

import Foundation
import SwiftData
import SwiftUI

struct DummyProject {
    static func createProject(
        name: String = "Test Project",
        type: ProjectType = .binary,
        color: Color = RakuColors.githubGreen,
        commitCount: Int = 50,
        startDate: Date = Date()
    ) -> Project {
        let project = Project(
            name: name,
            type: type,
            color: color,
            created_at: startDate
        )
        
        // Define the pattern for commits
        let patternOnDays = 3   // Number of consecutive days with commits
        let patternOffDays = 2  // Number of consecutive days without commits
        let patternLength = patternOnDays + patternOffDays
        
        // Add commits following the pattern starting from the project's start date
        for dayOffset in 0..<commitCount {
            // Determine if this day is an "on" day or an "off" day
            let patternPosition = dayOffset % patternLength
            let isCommitDay = patternPosition < patternOnDays
            
            // Calculate the date for this offset
            let commitDate = startDate.addingTimeInterval(Double(-dayOffset) * 86400)
            
            // Insert a commit only on an "on" day
            if isCommitDay {
                let commit = Commit(
                    date: commitDate,
                    intensity: 1,
                    project: project
                )
                project.commits.append(commit)
            }
        }
        
        return project
    }
    
    // Convenience method to create a project with commits spread over the last year
    static func createYearLongProject(
        name: String = "Year Long Project",
        type: ProjectType = .binary,
        color: Color = RakuColors.githubGreen
    ) -> Project {
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        return createProject(
            name: name,
            type: type,
            color: color,
            commitCount: 100,
            startDate: oneYearAgo
        )
    }
    
    // Convenience method to create a project with commits over the last month
    static func createMonthLongProject(
        name: String = "Month Long Project",
        type: ProjectType = .binary,
        color: Color = RakuColors.githubGreen
    ) -> Project {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return createProject(
            name: name,
            type: type,
            color: color,
            commitCount: 20,
            startDate: oneMonthAgo
        )
    }
    
    // Convenience method to create a project with commits over the last week
    static func createWeekLongProject(
        name: String = "Week Long Project",
        type: ProjectType = .binary,
        color: Color = RakuColors.githubGreen
    ) -> Project {
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
        return createProject(
            name: name,
            type: type,
            color: color,
            commitCount: 4,
            startDate: oneWeekAgo
        )
    }
}
