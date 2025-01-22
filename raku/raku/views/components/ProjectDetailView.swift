//
//  ProjectDetailView.swift
//  raku
//
//  Created by Anish Agrawal on 1/16/25.
//

import SwiftUI
import Foundation

struct ProjectDetailView: View {
    
    @State var project: Project
    
    @State private var showBulletCalendar = false
    @State private var showProjectEditor = false
    
    var body: some View {
        ScrollView {
            // stat group
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "chart.dots.scatter")
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
            .padding([.horizontal, .top])

            // bullet calendar
            VStack {
                Button(action: {
                    showBulletCalendar = true
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "calendar")
                        Text("Bullet Calendar")
                            .font(.headline.bold())
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 20)
            .background(Color(RakuColors.secondaryBackground))
            .cornerRadius(24)
            .padding([.horizontal, .top])
            
            VStack {
                Button(action: {
                    showProjectEditor = true
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "gear")
                        Text("Edit Project")
                            .font(.headline.bold())
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 20)
            .background(Color(RakuColors.secondaryBackground))
            .cornerRadius(24)
            .padding([.horizontal, .top])
        }
        .navigationBarTitle(project.name, displayMode: .inline)
        .fullScreenCover(isPresented: $showBulletCalendar, content: {
            let currentYear = Calendar.current.component(.year, from: Date())
            NavigationView {
                ScrollView {
                    VStack {
                        BulletCalendarView(project: project, year: currentYear)
                            .padding()
                    }
                }
                .navigationBarTitle("Bullet Calendar", displayMode: .inline)
                .navigationBarItems(trailing: Button("Close") {
                    showBulletCalendar = false
                })
            }
        })
        .sheet(isPresented: $showProjectEditor) {
            EditProjectSheetView(isPresented: $showProjectEditor, editingProject: Binding<Project?>($project))
        }
    }
}

#Preview {
    let project = DummyProject.createYearLongProject(name: "Test Project")
    ProjectDetailView(project: project)
}
