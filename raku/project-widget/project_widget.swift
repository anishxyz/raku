//
//  project_widget.swift
//  project-widget
//
//  Created by Anish Agrawal on 12/24/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ProjectEntry {
        let newProject = Project(name: "Placeholder", type: .binary, color: .blue)
        return ProjectEntry(date: Date(), project: newProject)
    }

    func getSnapshot(in context: Context, completion: @escaping (ProjectEntry) -> ()) {
        let newProject = Project(name: "Placeholder", type: .binary, color: .blue)
        let entry = ProjectEntry(date: Date(), project: newProject)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ProjectEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let newProject = Project(name: "Placeholder", type: .binary, color: .blue)
            let entry = ProjectEntry(date: entryDate, project: newProject)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct ProjectEntry: TimelineEntry {
    let date: Date
    let project: Project
}

struct project_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Name:")
            Text(entry.project.created_at.description)
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    project_widget()
} timeline: {
    ProjectEntry(date: .now, project: Project(name: "Example", type: .binary, color: .blue))
    ProjectEntry(date: Calendar.current.date(byAdding: .hour, value: 1, to: .now)!, project: Project(name: "Upcoming", type: .binary, color: .green))
}

