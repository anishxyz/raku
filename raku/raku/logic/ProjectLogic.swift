//
//  ProjectLogic.swift
//  raku
//
//  Created by Anish Agrawal on 12/24/24.
//

import SwiftData
import Foundation
import SwiftUI


struct ProjectLogic {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func createProject(name: String, type: ProjectType, color: Color) -> Project {
        let new_project = Project(name: name, type: type, color: color)
        self.modelContext.insert(new_project)
        try? self.modelContext.save()
        
        return new_project
    }
    
    func updateProject(project: Project, name: String?, color: Color?) -> Project {
        if let name = name {
            project.name = name
        }
        
        if let color = color {
            project._color = extractColorComponents(from: color)
        }
        
        try? self.modelContext.save()
        
        return project
    }
    
    func archiveProject(project: Project) {
        project.archived_at = Date()
        
        try? self.modelContext.save()
    }
}
