//
//  CommitEditor.swift
//  raku
//
//  Created by Anish Agrawal on 12/19/24.
//

import Foundation
import SwiftData
import SwiftUI


struct CommitEditorView: View {
    let project: Project
    @Environment(\.modelContext) private var modelContext
    @State private var todayCommit: Commit?
    
    var body: some View {
        Group {
            if project.type == .binary {
                CircleButton(isActive: todayCommit?.intensity == 1.0) {
                    handleCommitToggle()
                }
            }
        }
        .onAppear {
            loadTodayCommit()
        }
    }
    
    private func loadTodayCommit() {
        let today = Date().startOfDay
        todayCommit = project.commits.first(where: { $0.date == today })
        
        // Create an empty commit for today if none exists
        if todayCommit == nil {
            todayCommit = Commit(date: today, intensity: 0, project: project)
            modelContext.insert(todayCommit!)
        }
    }
    
    private func handleCommitToggle() {
        if let commit = todayCommit {
            commit.intensity = commit.intensity == 0 ? 1.0 : 0
            try? modelContext.save()
        }
    }
}

struct CircleButton: View {
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .strokeBorder(Color.gray, lineWidth: 2)
                .background(
                    Circle()
                        .fill(isActive ? Color.gray : Color.clear)
                )
                .frame(width: 24, height: 24)
        }
    }
}
