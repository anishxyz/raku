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
        var date: Date
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
//        case range
        case binary
    }
    
    @Model
    final class Project {
        @Attribute(.unique) var name: String
        @Relationship(deleteRule: .cascade, inverse: \Commit.project) var commits: [Commit]
        var created_at: Date
        var archived_at: Date?
        var type: ProjectType
        var commits_override: [Date: Int] // used for .github
        
        init(created_at: Date = Date(), type: ProjectType, name: String) {
            self.type = type
            self.name = name
            self.created_at = created_at.startOfDay
            self.archived_at = nil
            self.commits = []
            self.commits_override = [:]
        }
    }
}
