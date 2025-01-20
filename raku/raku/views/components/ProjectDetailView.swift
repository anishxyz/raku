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
//        let currentYear = Calendar.current.component(.year, from: Date())
//        ScrollView {
//            VStack {
//                BulletCalendarView(project: project, year: currentYear)
//                    .padding()
//            }
//        }
//        .toolbar(.hidden, for: .tabBar)
        
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text("Commitment Statistics")
                        .font(.headline.bold())
                    Spacer()
                }
                ProjectStatsView(project: project)
                Spacer()
            }
            .padding()
            .background(Color(RakuColors.secondaryBackground))
            .cornerRadius(24)
            .padding()
        }
        .navigationBarTitle(project.name, displayMode: .inline)
    }
}

#Preview {
    let project = DummyProject.createYearLongProject(name: "Test Project")
    ProjectDetailView(project: project)
}
