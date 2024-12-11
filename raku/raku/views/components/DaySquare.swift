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
    let intensity: Double
    
    @State private var showPopup: Bool = false

    
    var body: some View {
        let isBeforeProjectCreated = day < project.created_at && project.type != .github
        let isInFuture = day > Date.now.startOfDay
                
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
            } else if isInFuture {
                Rectangle()
                    .fill(Color.clear)
//                    .overlay(
//                        Rectangle()
//                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 2]))
//                            .foregroundColor(.gray)
//                    )
            } else {
                // Contribution square
                if contributionCount > 0 {
                    Rectangle()
                        .fill(project.color)
                        .saturation(intensity * 4.0)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            
            if showPopup {
                Text(String(format: "%.2f", intensity))
                    .frame(width: 50, height: 50)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .cornerRadius(4)
        .onTapGesture {
            showPopup = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showPopup = false
                }
            }
        }
    }
}
