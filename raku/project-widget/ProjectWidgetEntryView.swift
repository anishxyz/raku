//
//  ProjectWidgetEntryView.swift
//  raku
//
//  Created by Anish Agrawal on 12/29/24.
//

import SwiftUI

struct ProjectWidgetEntryView : View {
    var entry: ProjectProvider.Entry

    var body: some View {
        VStack {
            if let project = entry.project {
                ZStack {
                    ContributionGridView(project: project, daySize: 14.5, spacing: 4)
                        .clipCornerRadius(8, corners: [.allCorners])
                    
                    VStack {
                        HStack {
                            Text(project.name)
                                .font(.headline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.8)
                                    }
                                }
                            Spacer()
                        }
                        Spacer()
                    }
                }
            } else {
                Text("Project not available")
                    .font(.headline)
            }
        }
    }
}
