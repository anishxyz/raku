//
//  ContributionGridView.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftUI

struct ContributionGridView: View {
    @Bindable var project: Project

    private let daySize: CGFloat = 16  // will approx to this value
    private let spacing: CGFloat = 4
    
    @Environment(\.modelContext) var modelContext

    var body: some View {
        GeometryReader { proxy in
            // column math
            let availableWidth = proxy.size.width
            let (columnsCount, daySize) = computeColumns(totalWidth: availableWidth, desiredColumnWidth: daySize, spacing: spacing)
            
            // date layout
            let today = Date().startOfDay
            let gridEndDate = calculateStartDate(for: today)
            let totalDays = columnsCount * 7
            let gridStartDate = Calendar.current.date(byAdding: .day, value: -(totalDays - 1), to: gridEndDate) ?? gridEndDate
            let allDays = generateDates(from: gridStartDate, to: gridEndDate)
            
            // contribution stats
            let contributionCounts = getContributionCounts(for: allDays)
            let average = calculateAverage(from: contributionCounts)
            let maxCount = contributionCounts.max() ?? 1
            let minCount = contributionCounts.min() ?? 0
            let dsContext = DaySquareContext(average: average, max: maxCount, min: minCount)
            
            // cache
            let srd = RakuDate(date: gridStartDate)
            let erd = RakuDate(date: gridEndDate)
            
            let (existingCommits, newCommits) = ensureCommitsExist(
                for: allDays,
                existingCommits: project.commits.filter { $0.date >= srd && $0.date <= erd }
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(0..<columnsCount, id: \.self) { colIndex in
                        VStack(spacing: spacing) {
                            ForEach(0..<7, id: \.self) { rowIndex in
                                let dayIndex = colIndex * 7 + rowIndex
                                if dayIndex < allDays.count {
                                    let day = allDays[dayIndex]
                                    let rd = RakuDate(date: day)
                     
                                    DaySquare(
                                        day: day,
                                        project: project,
                                        commit: existingCommits[rd] ?? newCommits[rd],
                                        viewContext: dsContext
                                    )
                                    .frame(width: daySize, height: daySize)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                if project.type == .github {
                    fetchAndMergeContributions(for: project, startDate: gridStartDate, endDate: gridEndDate)
                }
            }
        }
        .frame(height: (daySize * 7) + (spacing * 6))
    }
    
    private func getContributionCounts(for days: [Date]) -> [Int] {
        // Create a dictionary directly using RakuDate
        let commitDict = Dictionary(
            project.commits.map { ($0.date, $0.intensity) },
            uniquingKeysWith: { first, _ in first }
        )
        
        // Convert input dates to RakuDate for lookup
        let contributionCounts = days.map { commitDict[RakuDate(date: $0)] ?? 0 }
        
        return contributionCounts
    }
    
    private func ensureCommitsExist(for days: [Date], existingCommits: [Commit]) -> ([RakuDate: Commit], [RakuDate: Commit]) {
        // Create dictionary of existing commits
        let existingDict = Dictionary(
            uniqueKeysWithValues: existingCommits.map { ($0.date, $0) }
        )
        
        // Create dictionary for new commits
        var newDict: [RakuDate: Commit] = [:]
        
        // Check each day and create commits where needed
        for day in days {
            let rd = RakuDate(date: day)
            if existingDict[rd] == nil {
                let commit = Commit(date: rd, intensity: 0, project: project)
                commit.project = project
                modelContext.insert(commit)
                newDict[rd] = commit
            }
        }
        
        // Save all new commits at once if any were created
        if !newDict.isEmpty {
            do {
                try modelContext.save()
            } catch {
                print("Failed to save commits: \(error)")
            }
        }
        
        return (existingDict, newDict)
    }
}

