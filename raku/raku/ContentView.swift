//
//  ContentView.swift
//  raku
//
//  Created by Anish Agrawal on 12/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ProjectsView()

//        TabView {
//            ProjectsView()
//                .tabItem {
//                    Label("Projects", systemImage: "folder")
//                }
//
//            TodosView()
//                .tabItem {
//                    Label("Todos", systemImage: "gear")
//                }
//        }
    }

}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
