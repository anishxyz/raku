//
//  DaySquare.swift
//  raku
//
//  Created by Anish Agrawal on 12/10/24.
//

import Foundation
import SwiftUI

struct DaySquareContext {
    var average: Double
    var max: Int
    var min: Int
}

struct DaySquare: View {
    let day: Date
    
    @Bindable var project: Project
    var commit: Commit?

    let viewContext: DaySquareContext?
    
    var body: some View {
        let contributionCount: Int = commit?.intensity ?? 0
        
        let intensity: Double
        if let dsContext = viewContext {
            intensity = normalize(count: contributionCount, average: dsContext.average, max: dsContext.max, min: dsContext.min)
        } else {
            intensity = Double(contributionCount)
        }
        
        let isBeforeProjectCreated = day < project.created_at && project.type != .github
        let isInFuture = day > Date.now.startOfDay
        
        return ZStack {
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
                        .fill(RakuColors.tertiaryBackground)
                }
            }
        }
        .cornerRadius(4)
    }
    
    private func normalize(count: Int, average: Double, max: Int, min: Int) -> Double {
        let maxDouble = Double(max)
        let minDouble = Double(min)
        let countDouble = Double(count)
        
        if maxDouble == average && minDouble == average {
            return 0.5
        }
        
        if countDouble >= average {
            if maxDouble == average {
                return 1.0
            }
            return 0.5 * ((countDouble - average) / (maxDouble - average)) + 0.5
        } else {
            if minDouble == average {
                return 0.0
            }
            return 0.5 * ((countDouble - average) / (average - minDouble)) + 0.5
        }
    }
}

#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
