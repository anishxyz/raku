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
    
    struct _Color: Codable {
       var red: Float
       var green: Float
       var blue: Float
       var opacity: Float
    }
    
    @Model
    final class Project {
        @Attribute(.unique) var name: String
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
        
        init(created_at: Date = Date(), type: ProjectType, name: String, color: Color = Color.orange) {
            self.type = type
            self.name = name
            self.created_at = created_at.startOfDay
            self.archived_at = nil
            self.commits = []
            self.commits_override = [:]
            
            // Extract RGBA components from the SwiftUI Color
            let uiColor = UIColor(color)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var o: CGFloat = 0

            uiColor.getRed(&r, green: &g, blue: &b, alpha: &o)

            // Initialize the _Color nested type
            self._color = _Color(
                red: Float(r),
                green: Float(g),
                blue: Float(b),
                opacity: Float(o)
            )
        }
    }
}
