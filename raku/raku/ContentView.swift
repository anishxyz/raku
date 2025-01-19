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
        TabView {
            NavigationStack {
                ProjectsView()
            }
            .tabItem {
                Label("Projects", systemImage: "rectangle.grid.1x2")
            }
            
            NavigationStack {
                TodosView()
            }
            .tabItem {
                Label("Todos", systemImage: "checkmark.square")
            }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
