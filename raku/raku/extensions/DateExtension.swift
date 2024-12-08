//
//  DateExtension.swift
//  raku
//
//  Created by Anish Agrawal on 12/7/24.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    static func randomDateInLastYear() -> Date {
        let day = arc4random_uniform(365) + 1
        let hour = arc4random_uniform(24)
        let minute = arc4random_uniform(60)
        let second = arc4random_uniform(60)
        
        let generated = Calendar.current.date(byAdding: .day, value: -Int(day), to: Date())!
            .addingTimeInterval(TimeInterval(hour * 3600 + minute * 60 + second))
        return generated.startOfDay
    }

    static func randomDateInLastWeek() -> Date {
        let day = arc4random_uniform(7) + 1
        let hour = arc4random_uniform(24)
        let minute = arc4random_uniform(60)
        let second = arc4random_uniform(60)
        
        let generated = Calendar.current.date(byAdding: .day, value: -Int(day), to: Date())!
            .addingTimeInterval(TimeInterval(hour * 3600 + minute * 60 + second))
        return generated.startOfDay
    }
}
