//
//  ProjectDetailView.swift
//  raku
//
//  Created by Anish Agrawal on 1/16/25.
//

import SwiftUI
import Foundation

struct ProjectDetailView: View {
    
    var project: Project
    
    var body: some View {
        let currentYear = Calendar.current.component(.year, from: Date())

        ScrollView {
            VStack {
                BulletCalendarView(project: project, year: currentYear)
                    .padding()
            }
        }
        .navigationBarTitle(project.name, displayMode: .inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

