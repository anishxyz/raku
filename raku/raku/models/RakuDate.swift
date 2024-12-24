//
//  RakuDate.swift
//  raku
//
//  Created by Anish Agrawal on 12/21/24.
//

import SwiftUI

struct RakuDate: Equatable, Hashable, Codable, Comparable {
    let year: Int
    let month: Int
    let day: Int
    
    var key: String {
        "\(year)-\(month)-\(day)"
    }

    init(date: Date, timeZone: TimeZone = .current) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!
    }
    
    static func < (lhs: RakuDate, rhs: RakuDate) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        if lhs.month != rhs.month {
            return lhs.month < rhs.month
        }
        return lhs.day < rhs.day
    }
}

//extension RakuDate {
//
//    init(year: Int, month: Int, day: Int) {
//        self.year = year
//        self.month = month
//        self.day = day
//    }
//    
//}
