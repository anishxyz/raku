//
//  ContributionGridView.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct ContributionGridView: View {
    var project: Project

    var daySize: CGFloat = 16  // will approx to this value
    var spacing: CGFloat = 4
    
    @Environment(\.modelContext) var modelContext
    
    @State var forceRefresh = false
    
    private var projectLogic: ProjectLogic {
        ProjectLogic(modelContext: modelContext)
    }
    
    @State private var computedDaySize: CGFloat = 16

    var body: some View {
        GeometryReader { proxy in
            // column math
            let availableWidth = proxy.size.width
            let (columnsCount, newDaySize) = computeColumns(totalWidth: availableWidth, desiredColumnWidth: daySize, spacing: spacing)
            
            // TODO: find a better way of doing this
            Color.clear
               .onAppear {
                   computedDaySize = newDaySize
               }
               .onChange(of: proxy.size.width) {
                   computedDaySize = newDaySize
               }
            
            // date layout
            let today = Date().startOfDay
            let gridEndDate = calculateStartDate(for: today)
            let totalDays = columnsCount * 7
            let gridStartDate = Calendar.current.date(byAdding: .day, value: -(totalDays - 1), to: gridEndDate) ?? gridEndDate
            let allDays = generateDates(from: gridStartDate, to: gridEndDate)
            
            // cache
            let srd = RakuDate(date: gridStartDate)
            let erd = RakuDate(date: gridEndDate)
            let newCache: [RakuDate: Commit] = project.commits
                .filter { $0.date >= srd && $0.date <= erd }
                .reduce(into: [:]) { result, commit in
                    result[commit.date] = commit
                }
        

            // contribution stats
            let contributionCounts = getContributionCounts(for: allDays, with: newCache)
            let average = calculateAverage(from: contributionCounts)
            let maxCount = contributionCounts.max() ?? 1
            let minCount = contributionCounts.min() ?? 0
            let dsContext = DaySquareContext(average: average, max: maxCount, min: minCount)
            
            // View
            HStack(spacing: spacing) {
                ForEach(0..<columnsCount, id: \.self) { colIndex in
                    DayColumnView(
                        colIndex: colIndex,
                        spacing: spacing,
                        computedDaySize: computedDaySize,
                        allDays: allDays,
                        commitCache: newCache,
                        dsContext: dsContext,
                        project: project
                    )
                }
            }
            .task {
                projectLogic.refresh(for: project, startDate: gridStartDate, endDate: gridEndDate)
                forceRefresh.toggle()
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: forceRefresh) {
                // Just reading needsRefresh triggers a re-render.
            }
        }
        .frame(height: (computedDaySize * 7) + (spacing * 6))
        .background(.clear)
    }
}

struct DayColumnView: View {
    let colIndex: Int
    let spacing: CGFloat
    let computedDaySize: CGFloat
    let allDays: [Date]
    let commitCache: [RakuDate: Commit]
    let dsContext: DaySquareContext
    let project: Project
    
    var body: some View {
        VStack(spacing: spacing) {
            // Always 7 rows per column
            ForEach(0..<7, id: \.self) { (rowIndex: Int) in
                let dayIndex = colIndex * 7 + rowIndex
                if dayIndex < allDays.count {
                    let day = allDays[dayIndex]
                    let rd = RakuDate(date: day)
                    
                    DaySquare(
                        day: day,
                        radius: spacing,
                        project: project,
                        commit: commitCache[rd],
                        viewContext: dsContext
                    )
                    .frame(width: computedDaySize, height: computedDaySize)
                }
            }
        }
    }
}
