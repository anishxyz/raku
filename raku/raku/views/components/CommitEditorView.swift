//
//  CommitEditor.swift
//  raku
//
//  Created by Anish Agrawal on 12/19/24.
//

import Foundation
import SwiftData
import SwiftUI
import WidgetKit


struct CommitEditorView: View {
    let project: Project
    @Environment(\.modelContext) private var modelContext
    @State private var todayCommit: Commit?
    
    private var commitLogic: CommitLogic {
        CommitLogic(modelContext: modelContext)
    }
    
    var body: some View {
        VStack {
            if project.type == .binary {
                SquareButton(isActive: todayCommit?.intensity == 1, activeColor: project.color) {
                    commitLogic.toggleCommit(commit: todayCommit)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                SquareButton(isActive: (todayCommit?.intensity ?? 0) > 0, activeColor: project.color) {
                    // not toggle-able
                }
            }
        }
        .onAppear {
            todayCommit = commitLogic.loadTodayCommit(project: project)
        }
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
