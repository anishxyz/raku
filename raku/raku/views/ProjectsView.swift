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
    @Query(sort: \Project.created_at, order: .forward) private var projects: [Project]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(projects, id: \.name) { project in
                        ProjectView(project: project)
                    }
                }
                .padding()
            }
            .navigationTitle("Projects")
        }
        
    }
}


#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
