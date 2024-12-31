//
//  ModelAlias.swift
//  raku
//
//  Created by Anish Agrawal on 12/24/24.
//

import Foundation
import SwiftData

typealias Commit = GraphSchemaV1.Commit
typealias Project = GraphSchemaV1.Project
typealias ProjectType = GraphSchemaV1.ProjectType

public extension Project {
    static let schema = SwiftData.Schema([
        Project.self,
        Commit.self
    ])
    
    static let container: ModelContainer = {
        let groupID = "group.xyz.anish.raku"
        let modelConfiguration = ModelConfiguration(groupContainer: .identifier(groupID))
        
        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

