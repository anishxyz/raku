//
//  GenericUtils.swift
//  raku
//
//  Created by Anish Agrawal on 1/16/25.
//

import Foundation
import SwiftUI

func calculateAverage(from counts: [Int]) -> Double {
    guard !counts.isEmpty else { return 0.0 }
    return Double(counts.reduce(0, +)) / Double(counts.count)
}

func getContributionCounts(
    for days: [Date],
    with commitCache: [RakuDate: Commit]
) -> [Int] {
    return days.map { date in
        let rd = RakuDate(date: date)
        return commitCache[rd]?.intensity ?? 0
    }
}

func getContributionCounts(
    for days: [RakuDate],
    with commitCache: [RakuDate: Commit]
) -> [Int] {
    return days.map { rd in
        return commitCache[rd]?.intensity ?? 0
    }
}
