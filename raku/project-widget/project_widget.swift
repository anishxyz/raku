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
    func placeholder(in context: Context) -> ProjectWidgetEntry {
        return ProjectWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ProjectWidgetEntry) -> ()) {
        let entry = ProjectWidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ProjectWidgetEntry] = []
        print("getTimeline called at \(Date())")
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ProjectWidgetEntry(date: entryDate)
            entries.append(entry)
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct ProjectWidgetEntry: TimelineEntry {
    let date: Date
}

struct project_widgetEntryView : View {
    @Query private var projects: [Project]
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let firstProject = projects.first(where: { $0.type == .binary }) {
                VStack {
                    HStack {
                        Text(firstProject.name)
                            .font(.headline)
                        Text(entry.date.formatted(.dateTime.hour().minute().second()))
                        Spacer()
                    }
                    ContributionGridView(project: firstProject, daySize: 10, spacing: 3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                Text("No projects available")
            }
            
        }
        .padding(.vertical, 24)
    }
}

struct project_widget: Widget {
    let kind: String = "project_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                project_widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    .modelContainer(for: [Project.self])
            } else {
                project_widgetEntryView(entry: entry)
                    .padding()
                    .background()
                    .modelContainer(for: [Project.self])

            }
        }
        .configurationDisplayName("Project Widget")
        .description("Contribution graph for a project")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
