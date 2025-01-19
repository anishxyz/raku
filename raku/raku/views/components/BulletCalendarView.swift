//
//  BulletCalendarView.swift
//  raku
//
//  Created by Anish Agrawal on 1/16/25.
//

import Foundation
import SwiftUI
import WidgetKit

struct BulletCalendarView: View {
    var project: Project
    var year: Int = 2025

    var columnSpacing: CGFloat = 8
    var rowSpacing: CGFloat = 2

    var tileWidth: CGFloat = 16
    var tileHeight: CGFloat = 16
    
    @State private var computedHeight: CGFloat = 1000

    var body: some View {
        GeometryReader { proxy in
            let availableWidth = proxy.size.width

            let (revisedColumnSpacing, revisedTileWidth, revisedRowSpacing, revisedTileHeight) = calculateLayout(availableWidth: availableWidth, columnSpacing: columnSpacing, tileWidth: tileWidth, rowSpacing: rowSpacing, tileHeight: tileHeight)
            
            Color.clear
               .onAppear {
                   computedHeight = (revisedTileHeight * 31) + (revisedRowSpacing * 30) + 72
               }
               .onChange(of: proxy.size.width) {
                   computedHeight = (revisedTileHeight * 31) + (revisedRowSpacing * 30) + 72
               }
            
            let (startDate, endDate) = calculateYearBounds(for: year)
            let allDays: [RakuDate] = generateRakuDates(from: startDate, to: endDate)
            let commitCache: [RakuDate: Commit] = project.commits
                .filter { $0.date >= RakuDate(date: startDate) && $0.date <= RakuDate(date: endDate) }
                .reduce(into: [:]) { result, commit in
                    result[commit.date] = commit
                }
            let contributionCounts = getContributionCounts(for: allDays, with: commitCache)
            let average = calculateAverage(from: contributionCounts)
            let maxCount = contributionCounts.max() ?? 1
            let minCount = contributionCounts.min() ?? 0
            let dsContext = DaySquareContext(average: average, max: maxCount, min: minCount)
            
            HStack(alignment: .top, spacing: revisedColumnSpacing) {
                ForEach(0..<12, id: \.self) { monthIndex in
                    MonthView(
                        monthIndex: monthIndex,
                        allDays: allDays,
                        revisedRowSpacing: revisedRowSpacing,
                        revisedTileWidth: revisedTileWidth,
                        revisedTileHeight: revisedTileHeight,
                        project: project,
                        commitCache: commitCache,
                        dsContext: dsContext
                    )
                }
            }
        }
        .frame(height: computedHeight)
    }
}


struct MonthView: View {
    let monthIndex: Int
    let allDays: [RakuDate]
    let revisedRowSpacing: CGFloat
    let revisedTileWidth: CGFloat
    let revisedTileHeight: CGFloat
    let project: Project
    let commitCache: [RakuDate: Commit]
    let dsContext: DaySquareContext
    
    private let monthLetters = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    private let monthLetters2 = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    private let monthFirstLetters = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    private let monthSecondLetters = ["a", "e", "a", "p", "a", "u", "u", "u", "e", "c", "o", "e"]
    private let monthThirdLetters = ["n", "b", "r", "r", "y", "n", "l", "g", "p", "t", "v", "c"]


    var body: some View {
        VStack(spacing: revisedRowSpacing) {
            Text(monthFirstLetters[monthIndex].uppercased())
                .font(.headline.monospaced())
            Text(monthSecondLetters[monthIndex].uppercased())
                .font(.headline.monospaced())
            Text(monthThirdLetters[monthIndex].uppercased())
                .font(.headline.monospaced())
                .padding(.bottom, 4)
            ForEach(allDays.filter { $0.month == monthIndex + 1 }, id: \.key) { day in
                DaySquare(
                    day: day,
                    radius: 6,
                    project: project,
                    commit: commitCache[day],
                    viewContext: dsContext,
                    futureShown: true
                )
                .frame(width: revisedTileWidth, height: revisedTileHeight)
            }
        }
    }
}


#Preview {
    let project = Project(name: "anishxyz", type: .github)
    BulletCalendarView(project: project)
}
