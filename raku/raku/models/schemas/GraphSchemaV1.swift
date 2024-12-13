//
//  SchemaV1.swift
//  raku
//
//  Created by Anish Agrawal on 12/3/24.
//

import Foundation
import SwiftData
import SwiftUI

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
        case binary
//        case range
    }

    @Model
    final class Project {
        var name: String
        @Relationship(deleteRule: .cascade, inverse: \Commit.project) var commits: [Commit]
        var created_at: Date
        var archived_at: Date?
        var type: ProjectType
        var commits_override: [Date: Int] // used for .github
        
        var _color: _Color
        
        var color: Color {
            Color(
                red: Double(_color.red),
                green: Double(_color.green),
                blue: Double(_color.blue),
                opacity: Double(_color.opacity)
            )
        }
        
        init(name: String, type: ProjectType, color: Color = Color.orange, created_at: Date = Date()) {
            self.type = type
            self.name = name
            self.created_at = created_at.startOfDay
            self.archived_at = nil
            self.commits = []
            self.commits_override = [:]
            self._color = extractColorComponents(from: color)
        }
    }
}
