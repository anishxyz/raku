//
//  RakuDateUtil.swift
//  raku
//
//  Created by Anish Agrawal on 12/21/24.
//

import SwiftUI

struct RakuDate: Equatable, Hashable, Codable {
    let year: Int
    let month: Int
    let day: Int
    
    init(date: Date, timeZone: TimeZone = .current) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        self.year = components.year!
        self.month = components.month!
        self.day = components.day!
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
