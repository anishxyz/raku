//
//  SchemaV1.swift
//  raku
//
//  Created by Anish Agrawal on 12/3/24.
//

import Foundation
import Foundation
import SwiftData

enum GraphSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Commit.self, Project.self]
    }
    
    @Model
    final class Commit {
        var timestamp: Date
        var intensity: Float
        var project: Project
        
        init(timestamp: Date?, intensity: Float, project: Project) {
            self.timestamp = timestamp ?? Date()
            self.intensity = intensity
            self.project = project
        }
    }
    
    enum ProjectType: String, Codable {
        case github
        case range
        case binary
    }
    
    
    @Model
    final class Project {
        var created_at: Date
        var archived_at: Date?
        var type: ProjectType
        
        @Relationship(inverse: \Commit.project) var commits: [Commit]
        
        init(created_at: Date?, type: ProjectType) {
            self.type = type
            self.created_at = created_at ?? Date()
            self.archived_at = nil
            self.commits = []
        }
    }
}
