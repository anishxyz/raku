//
//  ProjectsView.swift
//  raku
//cre
//  Created by Anish Agrawal on 12/4/24.
//

import Foundation
import SwiftUI
import SwiftData


struct ProjectsView: View {
    @Query(
        filter: #Predicate { $0.archived_at == nil },
        sort: \Project.created_at,
        order: .forward
    ) private var projects: [Project]
    @Environment(\.modelContext) private var modelContext

    @State private var isCreateSheetOpen = false
    @State private var editingProject: Project? = nil
    @StateObject private var projectManager = ProjectManager()

    var body: some View {
        NavigationView {
            List(projects, id: \.name) { project in
                ProjectView(project: project)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            self.projectManager.archiveProject(project: project)
                        } label: {
                            Label("Archive", systemImage: "archivebox")
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
                CreateProjectSheetView(isSheetPresented: $isCreateSheetOpen, editingProject: $editingProject)
                    .presentationDetents([.medium])
            }
        }
        .onAppear {
            projectManager.setModelContext(modelContext)
        }
    }
}


#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
