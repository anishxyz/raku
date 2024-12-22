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
                SquareButton(isActive: todayCommit?.intensity == 1, activeColor: project.color) {
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
            todayCommit = Commit(date: today, intensity: 0, project: project)
            modelContext.insert(todayCommit!)
            try? modelContext.save()
        }
    }
    
    private func handleCommitToggle() {
        if let commit = todayCommit {
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
        .buttonStyle(.borderless)
    }
}

struct SquareButton: View {
    let isActive: Bool
    let activeColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(isActive ? Color.clear : Color.gray, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isActive ? activeColor : Color.clear)
                    )
                    .frame(width: 24, height: 24)

                if isActive {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                }
            }
        }
        .buttonStyle(.borderless)
    }
}
