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
    @Environment(\.scenePhase) private var scenePhase

    @State private var todayCommit: Commit?

    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    private var commitLogic: CommitLogic {
        CommitLogic(modelContext: modelContext)
    }
    
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            if project.type == .binary {
                SquareButton(isActive: todayCommit?.intensity == 1, activeColor: project.color) {
                    commitLogic.toggleCommit(commit: todayCommit)
                    feedbackGenerator.notificationOccurred(.success)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                SquareButton(isActive: (todayCommit?.intensity ?? 0) > 0, activeColor: project.color) {
                    shakeButton()
                    feedbackGenerator.notificationOccurred(.error)
                }
                .offset(x: shakeOffset)
                .animation(
                    .easeInOut(duration: 0.2)
                        .repeatCount(3, autoreverses: true),
                    value: shakeOffset
                )
            }
        }
        .onAppear {
            todayCommit = commitLogic.loadTodayCommit(project: project)
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            // Force-refresh the commit for the new day
            todayCommit = commitLogic.loadTodayCommit(project: project)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                // We just became active (i.e., moved from background/suspended to foreground)
                todayCommit = commitLogic.loadTodayCommit(project: project)
            }
        }
    }
    
    private func shakeButton() {
        shakeOffset = -10
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shakeOffset = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shakeOffset = 0
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

#Preview { @MainActor in
    ContentView()
        .modelContainer(previewContainer)
}
