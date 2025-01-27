//
//  ProjectWidgetIntent.swift
//  raku
//
//  Created by Anish Agrawal on 12/29/24.
//

import WidgetKit
import AppIntents
import SwiftData

// Define a widgets configurable interface
struct ProjectWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Project"
    static var description = IntentDescription("Selects the contribution graph to display")


    @Parameter(title: "Project")
    var project: ProjectEntity?
    
    @Parameter(title: "Show Title", default: true)
    var showTitle: Bool
    
    init(project: ProjectEntity) {
        self.project = project
        self.showTitle = true
    }

    init() {
    }

}

// Connect app data model to widget configuration
struct ProjectEntity: AppEntity, Identifiable, Hashable {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from project: Project) {
        self.id = project.id
        self.name = project.name
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Project")
    static var defaultQuery = ProjectEntityQuery()
}


// define how to fetch App Entity
struct ProjectEntityQuery: EntityQuery, Sendable {
    func entities(for identifiers: [UUID]) async throws -> [ProjectEntity] {
        let modelContext = ModelContext(Project.container)
        let projects = try! modelContext.fetch(FetchDescriptor<Project>(predicate: #Predicate { identifiers.contains($0.id) }))
        return projects.map { ProjectEntity(from: $0) }
    }
    
    func suggestedEntities() async throws -> [ProjectEntity] {
        let modelContext = ModelContext(Project.container)
        let descriptor = FetchDescriptor<Project>(
            predicate: #Predicate<Project> { project in
                project.archived_at == nil
            }
        )
        let backyards = try! modelContext.fetch(descriptor)
        return backyards.map { ProjectEntity(from: $0) }
    }
    
    func defaultResult() async -> ProjectEntity? {
        try? await suggestedEntities().first
    }
}
