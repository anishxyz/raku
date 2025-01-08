//
//  DateUtils.swift
//  raku
//
//  Created by Anish Agrawal on 1/8/25.
//

import Foundation

func generateDates(from start: Date, to end: Date) -> [Date] {
    var dates: [Date] = []
    var current = start
    while current <= end {
        dates.append(current)
        current = Calendar.current.date(byAdding: .day, value: 1, to: current) ?? current
    }
    return dates
}


func generateRakuDates(from start: Date, to end: Date) -> [RakuDate] {
    var dates: [RakuDate] = []
    var calendar = Calendar(identifier: .gregorian)
    
    // Create date iterator starting from the start date
    var currentDate = start
    
    // Keep adding dates until we reach or exceed the end date
    while currentDate <= end {
        dates.append(RakuDate(date: currentDate))
        
        // Move to the next day
        if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = nextDate
        } else {
            break // Break if we can't create the next date (shouldn't happen in normal circumstances)
        }
    }
    
    return dates
}
