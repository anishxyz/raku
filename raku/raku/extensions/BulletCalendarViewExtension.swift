//
//  BulletCalendarViewExtension.swift
//  raku
//
//  Created by Anish Agrawal on 1/16/25.
//

import Foundation

extension BulletCalendarView {
    
    func calculateLayout(availableWidth: CGFloat, columnSpacing: CGFloat, tileWidth: CGFloat, rowSpacing: CGFloat, tileHeight: CGFloat) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        // Calculate total spacing between columns with a scaling factor for spacing
        let baseColumnSpacing: CGFloat = columnSpacing
        let scalingFactor: CGFloat = 0.75
        let totalSpacing = baseColumnSpacing * 11 * (1 + scalingFactor)

        // Calculate revised tile width with adjusted column spacing
        let adjustedColumnSpacing = baseColumnSpacing * (1 + scalingFactor)
        let revisedTileWidth = (availableWidth - totalSpacing) / 12

        // Scale row spacing and tile height proportionally
        let adjustedRowSpacing = rowSpacing * (1 + scalingFactor)
//        let adjustedTileHeight = tileHeight * (1 + scalingFactor)

        return (adjustedColumnSpacing, revisedTileWidth, adjustedRowSpacing, revisedTileWidth)
    }
    
    func calculateYearBounds(for year: Int? = nil) -> (Date, Date) {
        let calendar = Calendar.current
        let targetYear = year ?? calendar.component(.year, from: Date())

        // Calculate the first and last date of the target year
        let startOfYear = calendar.date(from: DateComponents(year: targetYear, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: targetYear, month: 12, day: 31, hour: 23, minute: 59, second: 59))!
        
        return (startOfYear, endOfYear)
    }
}
