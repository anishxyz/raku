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
    @Query private var projects: [Project]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(projects, id: \.name) { project in
                        VStack(alignment: .leading) {
                            Text(project.name)
                                .font(.headline)
                            Text("Type: \(project.type.rawValue.capitalized)")
                                .font(.subheadline)
                            Text("Created At: \(project.created_at.formatted(date: .numeric, time: .omitted))")
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Projects")
        }
        
    }
}


#Preview {
    do {
        // Create an in-memory model container with mock data
        let container = try ModelContainer(for: Project.self)
        let context = container.mainContext
        
        // Insert mock data into the context
        let mockProjects = [
            GraphSchemaV1.Project(created_at: Date(), type: .github, name: "Project Alpha"),
            GraphSchemaV1.Project(created_at: Date().addingTimeInterval(-86400), type: .range, name: "Project Beta"),
            GraphSchemaV1.Project(created_at: Date().addingTimeInterval(-604800), type: .binary, name: "Project Gamma")
        ]
        
        for project in mockProjects {
            context.insert(project)
        }
        
        return ProjectsView()
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
