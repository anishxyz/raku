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

    var body: some View {
        GeometryReader { proxy in
            // column math
            let availableWidth = proxy.size.width
            let (columnsCount, daySize) = computeColumns(totalWidth: availableWidth, desiredColumnWidth: daySize, spacing: spacing)
            
            // date layout
            let today = Date().startOfDay
            let endDate = calculateStartDate(for: today)
            let totalDays = columnsCount * 7
            let startDate = Calendar.current.date(byAdding: .day, value: -(totalDays - 1), to: endDate) ?? endDate
            let allDays = generateDates(from: startDate, to: endDate)
            
            // contribution stats
            let contributionCounts = allDays.map { getContributionCount(for: $0) }
            let average = calculateAverage(from: contributionCounts)
            let maxCount = contributionCounts.max() ?? 1
            let minCount = contributionCounts.min() ?? 0

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(0..<columnsCount, id: \.self) { colIndex in
                        VStack(spacing: spacing) {
                            ForEach(0..<7, id: \.self) { rowIndex in
                                let dayIndex = colIndex * 7 + rowIndex
                                if dayIndex < allDays.count {
                                    let day = allDays[dayIndex]
                                    let count = getContributionCount(for: day)
                                    let normalizedValue = normalize(count: count, average: average, max: maxCount, min: minCount)
                                                                        
                                    DaySquare(
                                        day: day,
                                        project: project,
                                        contributionCount: getContributionCount(for: day),
                                        intensity: normalizedValue
                                    )
                                    .frame(width: daySize, height: daySize)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(height: (daySize * 7) + (spacing * 6))
        .onAppear {
            if project.type == .github {
                fetchAndMergeContributions(for: project)
            }
        }
    }

    private func getContributionCount(for day: Date) -> Int {
        if project.type == .github {
            return project.commits_override[RakuDate(date: day)] ?? 0
        } else {
            return project.commits.filter { $0.date == RakuDate(date: day) }.count
        }
    }
    
    private func fetchAndMergeContributions(for project: Project) {
        let username = project.name
        
        RakuAPIManager.shared.fetchContributions(for: username) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let newContributions = Dictionary(
                        uniqueKeysWithValues: response.contributions.map { ($0.date, $0.count) }
                    )
                    // overwrite
                    for (date, count) in newContributions {
                        project.commits_override[RakuDate(date: date)] = count
                    }
                    
                    // Update created_at to the earliest date in commits_override
//                    if let earliestDate = project.commits_override.keys.min() {
//                        project.created_at = earliestDate
//                    }
                }
            case .failure(let error):
                print("Failed to fetch contributions: \(error)")
            }
        }
    }

}
