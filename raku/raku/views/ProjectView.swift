//
//  ProjectView.swift
//  raku
//
//  Created by Anish Agrawal on 12/5/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ProjectView: View {
    @Bindable var project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Project info
            VStack(alignment: .leading) {
                HStack {
                    Text(project.name)
                        .font(.headline)
                    Spacer()
                    CommitEditorView(project: project)
                }
                                
                ContributionGridView(project: project)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(RakuColors.secondaryBackground))
            .cornerRadius(24)
        }
    }
}


#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
