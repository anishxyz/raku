//
//  ProjectUseCase.swift
//  raku
//
//  Created by Anish Agrawal on 12/13/24.
//

import SwiftData
import SwiftUI

@MainActor
class ProjectManager: ObservableObject {
    private var modelContext: ModelContext?
        
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func createProject(name: String, type: ProjectType, color: Color) {
        guard let modelContext = modelContext else { return }

        let newProject = Project(name: name, type: type, color: color)
        modelContext.insert(newProject)
        
        try? modelContext.save()
    }
    
    func updateProject(project: Project, name: String, color: Color) {
        guard let modelContext = modelContext else { return }

        project.name = name
        project._color = extractColorComponents(from: color)
        
        try? modelContext.save()
    }
    
    func archiveProject(project: Project) -> Void {
        guard let modelContext = modelContext else { return }

        project.archived_at = Date()
        
        try? modelContext.save()
    }
    
    func deleteProject(project: Project) -> Void {
        guard let modelContext = modelContext else { return }

        project.archived_at = Date()
        
        try? modelContext.save()
    }
}
