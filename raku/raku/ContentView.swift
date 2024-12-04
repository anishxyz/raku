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
    @Query private var projects: [Project]

    var body: some View {
        Text("hello")
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Project.self, inMemory: true)
}
