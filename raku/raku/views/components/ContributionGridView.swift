//
//  ContributionGridView.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftUI

struct ContributionGridView: View {
    let project: Project

    private let daySize: CGFloat = 16
    private let spacing: CGFloat = 4

    var body: some View {
        GeometryReader { proxy in
            let availableWidth = proxy.size.width
            let columnsCount = calculateColumnCount(for: availableWidth)

            let today = Date().startOfDay
            let endDate = calculateStartDate(for: today)
            let totalDays = columnsCount * 7
            let startDate = Calendar.current.date(byAdding: .day, value: -(totalDays - 1), to: endDate) ?? endDate
            let allDays = generateDates(from: startDate, to: endDate)
            
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
        .frame(height: (daySize * 7) + (spacing * 6)) // 7 rows and spacing
        .onAppear {
            if project.type == .github {
                fetchAndMergeContributions(for: project)
            }
        }
    }
    
    private func calculateAverage(from counts: [Int]) -> Double {
       guard !counts.isEmpty else { return 0.0 }
       return Double(counts.reduce(0, +)) / Double(counts.count)
   }
    
    private func normalize(count: Int, average: Double, max: Int, min: Int) -> Double {
        let maxDouble = Double(max)
        let minDouble = Double(min)
        let countDouble = Double(count)
        if countDouble >= average {
            return 0.5 * ((countDouble - average) / (maxDouble - average)) + 0.5
        } else {
            return 0.5 * ((countDouble - average) / (average - minDouble)) + 0.5
        }
    }
    
    private func calculateStartDate(for today: Date) -> Date {
        let calendar = Calendar.current
        // Find the next Saturday
        let weekday = calendar.component(.weekday, from: today)
        let daysUntilSaturday = (7 - weekday + 7) % 7
        let upcomingSaturday = calendar.date(byAdding: .day, value: daysUntilSaturday, to: today) ?? today
        return upcomingSaturday
    }

    private func calculateColumnCount(for width: CGFloat) -> Int {
        let totalItemWidth = daySize + spacing
        let count = Int(floor(width / totalItemWidth))
        return max(count, 1)
    }

    private func generateDates(from start: Date, to end: Date) -> [Date] {
        var dates: [Date] = []
        var current = start
        while current <= end {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current) ?? current
        }
        return dates
    }

    private func getContributionCount(for day: Date) -> Int {
        if project.type == .github {
            return project.commits_override[day] ?? 0
        } else {
            return project.commits.filter { $0.date == day }.count
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
                        project.commits_override[date] = count
                    }
                    
                    // Update created_at to the earliest date in commits_override
                    if let earliestDate = project.commits_override.keys.min() {
                        project.created_at = earliestDate
                    }
                }
            case .failure(let error):
                print("Failed to fetch contributions: \(error)")
            }
        }
    }
}
