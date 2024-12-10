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
            let totalDays = columnsCount * 7
            let startDate = Calendar.current.date(byAdding: .day, value: -(totalDays - 1), to: today) ?? today
            let allDays = generateDates(from: startDate, to: today)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(0..<columnsCount, id: \.self) { colIndex in
                        VStack(spacing: spacing) {
                            ForEach(0..<7, id: \.self) { rowIndex in
                                let dayIndex = colIndex * 7 + rowIndex
                                if dayIndex < allDays.count {
                                    let day = allDays[dayIndex]
                                    DaySquare(day: day, project: project)
                                        .frame(width: daySize, height: daySize)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(height: (daySize * 7) + (spacing * 6)) // 7 rows and spacing
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
    
    struct DaySquare: View {
        let day: Date
        let project: Project
        
        var body: some View {
            let hasCommit = project.commits.contains(where: { $0.date == day })
            let isBeforeProjectCreated = day < project.created_at
            
            ZStack {
                if isBeforeProjectCreated {
                    // Before project creation date
                    Rectangle()
                        .fill(Color.clear)
                        .overlay(
                            Rectangle()
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 2]))
                                .foregroundColor(.gray)
                        )
                } else {
                    // After project creation date
                    if hasCommit {
                        Rectangle()
                            .fill(Color.orange)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
            }
            .cornerRadius(4)
        }
    }
}
