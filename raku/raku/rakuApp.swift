//
//  rakuApp.swift
//  raku
//
//  Created by Anish Agrawal on 12/3/24.
//

import SwiftUI
import SwiftData

@main
struct rakuApp: App {
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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
