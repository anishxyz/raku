//
//  Commit.swift
//  raku
//
//  Created by Anish Agrawal on 12/3/24.
//

import Foundation
import SwiftData

@Model
final class Commit {
    var timestamp: Date
    var intensity: Float
    
    init(timestamp: Date, intensity: Float) {
        self.timestamp = timestamp
        self.intensity = intensity
    }
}
