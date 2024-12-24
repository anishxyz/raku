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
        #Unique<Commit>([\.id], [\.project, \.dateKey])
        
        @Attribute(.unique) var id: UUID = UUID()
        @Attribute var dateKey: String
        var date: RakuDate
        var intensity: Int
        var project: Project?
                
        init(date: Date = Date(), intensity: Int, project: Project?) {
            self.date = RakuDate(date: date)
            self.intensity = intensity
            self.project = project
            self.dateKey = RakuDate(date: date).key
        }
        
        init(date: RakuDate, intensity: Int, project: Project?) {
            self.date = date
            self.intensity = intensity
            self.project = project
            self.dateKey = date.key
        }
    }
    
    enum ProjectType: String, Codable {
        case github
        case binary
    }

    @Model
    final class Project {
        @Attribute(.unique) var id: UUID = UUID()
        var name: String
        @Relationship(deleteRule: .cascade, inverse: \Commit.project) var commits: [Commit]
        var created_at: Date
        var archived_at: Date?
        var type: ProjectType
        
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
            self.created_at = created_at
            self.archived_at = nil
            self.commits = []
            self._color = extractColorComponents(from: color)
        }
    }
}
