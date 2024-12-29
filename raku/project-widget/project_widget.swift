//
//  project_widget.swift
//  project-widget
//
//  Created by Anish Agrawal on 12/24/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    
    var sharedModelContainer: ModelContainer = {
        let groupID = "group.xyz.anish.raku"
        let schema = Schema([Project.self])
        let modelConfiguration = ModelConfiguration(schema: schema, groupContainer: .identifier(groupID))
        
        do {
            return try ModelContainer(for: Project.self, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var modelContext: ModelContext {
        ModelContext(sharedModelContainer)
    }

    func placeholder(in context: Context) -> ProjectWidgetEntry {
        return ProjectWidgetEntry(date: Date(), project: nil)
    }
    
    func createEntry(completion: @escaping (ProjectWidgetEntry) -> Void) {
        let descriptor = FetchDescriptor<Project>(
            predicate: #Predicate<Project> { project in
                project.archived_at == nil
            },
            sortBy: [SortDescriptor(\.created_at, order: .reverse)]
        )
                
        do {
            let projects = try modelContext.fetch(descriptor)
            let entry = ProjectWidgetEntry(
                date: Date(),
                project: projects.first
            )
            completion(entry)
        } catch {
            print("Error fetching project: \(error)")
            completion(ProjectWidgetEntry(date: Date()))
        }
    }

    func getSnapshot(in context: Context, completion: @escaping (ProjectWidgetEntry) -> ()) {
        createEntry { entry in
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        createEntry { entry in
            // Create multiple entries for the next few hours
            var entries: [ProjectWidgetEntry] = []
            let currentDate = Date()
            
            // Add entries for the next 24 hours, updating every hour
            for hourOffset in 0...1 {
                guard let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) else {
                    continue
                }
                
                let entry = ProjectWidgetEntry(date: entryDate, project: entry.project)
                entries.append(entry)
            }
            
            // Set timeline to refresh after the last entry
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct ProjectWidgetEntry: TimelineEntry {
    var date: Date
    var project: Project?
}

struct project_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let firstProject = entry.project {
                ContributionGridView(project: firstProject, daySize: 14.5, spacing: 4)
                    .clipCornerRadius(8, corners: [.allCorners])
            } else {
                Text("No projects available")
            }
        }
    }
}

struct project_widget: Widget {
    let kind: String = "project_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                project_widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                project_widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Project Widget")
        .description("Contribution graph for a project")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
