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
                CircleButton(isActive: todayCommit?.intensity == 1) {
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
        let todayRakuDate = RakuDate(date: today)
        todayCommit = project.commits.first(where: { $0.date == todayRakuDate })
        
        // Create an empty commit for today if none exists
        if todayCommit == nil {
            print("here2")
            todayCommit = Commit(date: today, intensity: 0, project: project)
            modelContext.insert(todayCommit!)
            try? modelContext.save()
        }
    }
    
    private func handleCommitToggle() {
        if let commit = todayCommit {
            print("here1")
            commit.intensity = commit.intensity == 0 ? 1 : 0
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
