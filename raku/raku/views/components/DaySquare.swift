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
    @Bindable var project: Project
    let contributionCount: Int
    let intensity: Double
    
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
            } else {
                // Contribution square
                if contributionCount > 0 {
                    if project.type == .github {
                        Rectangle()
                            .fill(project.color)
                            .saturation(max(intensity, 0.25))
                    } else {
                        Rectangle()
                            .fill(project.color)
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
        }
        .cornerRadius(4)
    }
}

#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
