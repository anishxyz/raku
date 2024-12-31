//
//  project_widget.swift
//  project-widget
//
//  Created by Anish Agrawal on 12/24/24.
//

import WidgetKit
import SwiftUI
import SwiftData


struct ProjectWidgetEntry: TimelineEntry {
    var date: Date
    var project: Project?
    
    static var empty: Self {
        Self(date: .now)
    }
}

struct ProjectProvider: AppIntentTimelineProvider {
    
    var modelContext: ModelContext {
        ModelContext(Project.container)
    }
    
    func projects(for configuration: ProjectWidgetIntent) -> [Project] {
        if let project = configuration.project {
            let selectedID = project.id
            let descriptor = FetchDescriptor<Project>(
                predicate: #Predicate<Project> { project in
                    project.id == selectedID && project.archived_at == nil
                }
            )
            return try! modelContext.fetch(descriptor)
        }
        return []
    }
    
    func placeholder(in context: Context) -> ProjectWidgetEntry {
        let latestProject = try? modelContext.fetch(FetchDescriptor<Project>(sortBy: [SortDescriptor(\.created_at, order: .reverse)])).first
        return ProjectWidgetEntry(
            date: .now,
            project: latestProject
        )
    }
    
    func snapshot(for configuration: ProjectWidgetIntent, in context: Context) async -> ProjectWidgetEntry {
        let projects = projects(for: configuration)
        guard let project = projects.first else {
            return .empty
        }
        
        return ProjectWidgetEntry(date: .now, project: project)
    }
    
    func timeline(for configuration: ProjectWidgetIntent, in context: Context) async -> Timeline<ProjectWidgetEntry> {
        let projects = projects(for: configuration)
        guard let project = projects.first else {
            return Timeline(
                entries: [.empty],
                policy: .never
            )
        }
        
        let entry = ProjectWidgetEntry(date: .now, project: project)
        return Timeline(entries: [entry], policy: .never)
    }

    func recommendations() -> [AppIntentRecommendation<ProjectWidgetIntent>] {
        []
    }
}

struct project_widget: Widget {
    let kind: String = "project_widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ProjectWidgetIntent.self,
            provider: ProjectProvider()
        ) { entry in
            if #available(iOS 17.0, *) {
                ProjectWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ProjectWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Project Widget")
        .description("Contribution graph for a project")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
