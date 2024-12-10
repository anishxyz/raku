//
//  DaySquare.swift
//  raku
//
//  Created by Anish Agrawal on 12/10/24.
//

import Foundation
import SwiftUI

struct DaySquare: View {
    let day: Date
    let project: Project
    let contributionCount: Int
    
    var body: some View {
        let isBeforeProjectCreated = day < project.created_at && project.type != .github
        
        ZStack {
            if isBeforeProjectCreated {
                // Before project creation date for non-GitHub projects
                Rectangle()
                    .fill(Color.clear)
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 2]))
                            .foregroundColor(.gray)
                    )
            } else {
                // Contribution square
                if contributionCount > 0 {
                    Rectangle()
                        .fill(Color.orange)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
        }
        .cornerRadius(4)
    }
}
