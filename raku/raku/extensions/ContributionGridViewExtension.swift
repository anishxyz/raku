//
//  ContributionGridViewExtension.swift
//  raku
//
//  Created by Anish Agrawal on 12/20/24.
//

import SwiftUI
import Foundation

extension ContributionGridView {
    /// Computes the best fitting column count and column width such that
    /// 1. The total occupies the given `width`.
    /// 2. The final column width is as close to `daySize` as possible.
    /// 3. There are (count - 1) spacings between columns.
    func computeColumns(
        totalWidth: CGFloat,
        desiredColumnWidth daySize: CGFloat,
        spacing: CGFloat
    ) -> (count: Int, columnWidth: CGFloat) {
        
        // Edge case: if totalWidth is zero or negative,
        // just bail out with a single column at desired daySize
        guard totalWidth > 0 else {
            return (count: 1, columnWidth: daySize)
        }
        
        // A naive guess for how many columns might fit based on desired width
        // and spacing. We'll also test around this guess to find the best match.
        let approximateCount = Int(round((totalWidth + spacing) / (daySize + spacing)))
        
        // We’ll look at a small range around approximateCount, including a fallback to at least 1 column.
        let possibleCounts = [
            max(1, approximateCount - 1),
            max(1, approximateCount),
            max(1, approximateCount + 1)
        ]
        
        var bestCount = 1
        var bestColumnWidth = daySize
        var smallestDifference = CGFloat.greatestFiniteMagnitude
        
        for candidateCount in possibleCounts {
            // The formula for the candidate column width when we have candidateCount columns,
            // each separated by (candidateCount - 1) spacings, must sum to totalWidth:
            //
            //   candidateCount * columnWidth + (candidateCount - 1) * spacing = totalWidth
            //
            // => columnWidth = (totalWidth - (candidateCount - 1) * spacing) / candidateCount
            //
            let candidateWidth = (totalWidth - spacing * CGFloat(candidateCount - 1)) / CGFloat(candidateCount)
            
            // Find how close this candidate width is to the desired daySize
            let diff = abs(candidateWidth - daySize)
            if diff < smallestDifference {
                smallestDifference = diff
                bestCount = candidateCount
                bestColumnWidth = candidateWidth
            }
        }
        
        return (count: bestCount, columnWidth: bestColumnWidth)
    }
    
    
    func calculateAverage(from counts: [Int]) -> Double {
        guard !counts.isEmpty else { return 0.0 }
        return Double(counts.reduce(0, +)) / Double(counts.count)
    }
    
    func normalize(count: Int, average: Double, max: Int, min: Int) -> Double {
        let maxDouble = Double(max)
        let minDouble = Double(min)
        let countDouble = Double(count)
        
        if maxDouble == average && minDouble == average {
            return 0.5
        }
        
        if countDouble >= average {
            if maxDouble == average {
                return 1.0
            }
            return 0.5 * ((countDouble - average) / (maxDouble - average)) + 0.5
        } else {
            if minDouble == average {
                return 0.0
            }
            return 0.5 * ((countDouble - average) / (average - minDouble)) + 0.5
        }
    }
    
    func calculateStartDate(for today: Date) -> Date {
        let calendar = Calendar.current
        // Find the next Saturday
        let weekday = calendar.component(.weekday, from: today)
        let daysUntilSaturday = (7 - weekday + 7) % 7
        let upcomingSaturday = calendar.date(byAdding: .day, value: daysUntilSaturday, to: today) ?? today
        return upcomingSaturday
    }

    func generateDates(from start: Date, to end: Date) -> [Date] {
        var dates: [Date] = []
        var current = start
        while current <= end {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current) ?? current
        }
        return dates
    }
}
