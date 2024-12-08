//
//  SchemaV1.swift
//  raku
//
//  Created by Anish Agrawal on 12/3/24.
//

import Foundation
import SwiftData

enum GraphSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(0, 1, 0)
    
    static var models: [any PersistentModel.Type] {
        [Commit.self, Project.self]
    }
    
    @Model
    final class Commit {
        @Attribute(.unique) var date: Date
        var intensity: Float
        var project: Project?
        
        init(date: Date = Date(), intensity: Float, project: Project?) {
            self.date = date.startOfDay
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
        @Attribute(.unique) var name: String
        
        @Relationship(deleteRule: .cascade, inverse: \Commit.project) var commits: [Commit]
        
        init(created_at: Date?, type: ProjectType, name: String) {
            self.type = type
            self.name = name
            self.created_at = created_at ?? Date()
            self.archived_at = nil
            self.commits = []
        }
    }
}
