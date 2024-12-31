//
//  ProjectsView.swift
//  raku
//cre
//  Created by Anish Agrawal on 12/4/24.
//

import Foundation
import SwiftUI
import SwiftData
import WidgetKit

struct ProjectsView: View {
    @Query(
        filter: #Predicate { $0.archived_at == nil },
        sort: \Project.created_at,
        order: .reverse
    ) private var projects: [Project]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    @State private var isCreateSheetOpen = false
    @State private var editingProject: Project? = nil
    
    private var projectLogic: ProjectLogic {
        ProjectLogic(modelContext: modelContext)
    }
    
    private var commitLogic: CommitLogic {
        CommitLogic(modelContext: modelContext)
    }

    var body: some View {
        NavigationView {
            List(projects, id: \.id) { project in
                ProjectView(project: project)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            projectLogic.archiveProject(project: project)
                            WidgetCenter.shared.reloadAllTimelines()
                        } label: {
                            Label("Archive", systemImage: "archivebox")
                        }
                    }
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
            .listStyle(PlainListStyle())
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isCreateSheetOpen = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .clipShape(.circle)
                    .buttonStyle(.bordered)
                    .tint(.orange)
                }
            }
            .sheet(isPresented: $isCreateSheetOpen) {
                ZStack {
                    if colorScheme == .dark {
                        Color.black
                            .ignoresSafeArea()
                    }
                    CreateProjectSheetView(isSheetPresented: $isCreateSheetOpen, editingProject: $editingProject)
                        .presentationDetents([.medium])
               }
            }
        }
    }
}


#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
