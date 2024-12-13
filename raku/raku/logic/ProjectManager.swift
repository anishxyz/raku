//
//  ProjectUseCase.swift
//  raku
//
//  Created by Anish Agrawal on 12/13/24.
//

import SwiftData
import SwiftUI

class ProjectManager: ObservableObject {
    @Environment(\.modelContext) private var modelContext

    // Add a task
    func createProject(name: String, type: ProjectType, color: Color) {
        let newProject = Project(name: name, type: type, color: color)
        modelContext.insert(newProject)
        
        try? modelContext.save()
    }
    
    func updateProject(project: Project, name: String, color: Color) {
        project.name = name
        project._color = extractColorComponents(from: color)
        
        try? modelContext.save()
    }
    
    func deleteProject(project: Project) {
        project.archived_at = Date()
        
        try? modelContext.save()
    }
}
