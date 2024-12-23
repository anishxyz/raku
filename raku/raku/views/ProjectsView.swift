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
        order: .reverse
    ) private var projects: [Project]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    @State private var isCreateSheetOpen = false
    @State private var editingProject: Project? = nil

    var body: some View {
        NavigationView {
            List(projects, id: \.id) { project in
                ProjectView(project: project)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing) {
                        Button(role: .cancel) {
                            archiveProject(project: project)
                        } label: {
                            Label("Archive", systemImage: "archivebox")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        if project.type == .binary {
                            Button {
                                toggleTodayCommit(project: project)
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
    
    func archiveProject(project: Project) -> Void {
        project.archived_at = Date()
        
        try? modelContext.save()
    }
    
    private func toggleTodayCommit(project: Project) {
        let today = Date().startOfDay
        let todayRakuDate = RakuDate(date: today)
        var todayCommit = project.commits.first(where: { $0.date == todayRakuDate })
        
        // Create an empty commit for today if none exists
        if todayCommit == nil {
            todayCommit = Commit(date: today, intensity: 0, project: project)
            modelContext.insert(todayCommit!)
        }
        
        if let commit = todayCommit {
            commit.intensity = commit.intensity == 0 ? 1 : 0
        }
        
        try? modelContext.save()
    }
}


#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
