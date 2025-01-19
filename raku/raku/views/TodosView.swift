//
//  TodosView.swift
//  raku
//
//  Created by Anish Agrawal on 12/4/24.
//

import Foundation
import SwiftUI
import WidgetKit
import SwiftData


struct TodosView: View {
    @Query(
        filter: #Predicate { $0.archived_at == nil },
        sort: \Project.created_at,
        order: .reverse
    ) private var projects: [Project]
    @Environment(\.modelContext) private var modelContext

    private var projectLogic: ProjectLogic {
        ProjectLogic(modelContext: modelContext)
    }
    
    private var commitLogic: CommitLogic {
        CommitLogic(modelContext: modelContext)
    }

    var body: some View {
        List(projects, id: \.id) { project in
            ProjectTodoView(project: project)
                .swipeActions(edge: .leading) {
                    if project.type == .binary {
                        Button {
                            commitLogic.toggleTodayCommit(project: project)
                            WidgetCenter.shared.reloadAllTimelines()
                        } label: {
                            Label("Done", systemImage: "checkmark.square")
                        }
                        .tint(.green)
                    }
                }
        }
        .toolbar(.visible, for: .tabBar)
        .listStyle(PlainListStyle())
        .navigationTitle("TODOS")
    }
}

struct ProjectTodoView: View {
    @State var project: Project
    @Environment(\.modelContext) private var modelContext
    @State private var todayCommit: Commit?
    
    private var commitLogic: CommitLogic {
        CommitLogic(modelContext: modelContext)
    }
    
    var body: some View {
        HStack {
            Text(project.name)
                .font(.body.monospaced())
                .strikethrough(todayCommit?.intensity ?? 0 > 0, color: .gray)
                .foregroundColor(todayCommit?.intensity ?? 0 > 0 ? .gray.opacity(0.6) : .primary)
            Spacer()
            CommitEditorView(project: project)
        }
        .onAppear {
            todayCommit = commitLogic.loadTodayCommit(project: project)
        }
    }
}
