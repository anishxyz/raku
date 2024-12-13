//
//  CreateProjectSheetView.swift
//  raku
//
//  Created by Anish Agrawal on 12/13/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateProjectSheetView: View {
    @Binding var isSheetPresented: Bool
    @Binding var editingProject: Project?
    @State private var projectName: String = ""
    @State private var selectedType: ProjectType = .github
    @State private var selectedColor: Color = .orange
    
    @EnvironmentObject var projectManager: ProjectManager

    var body: some View {
        VStack(spacing: 20) {
            Text(editingProject == nil ? "Add a New Project" : "Edit Project")
                .font(.headline)

            TextField("Project Name", text: $projectName)
                .textFieldStyle(.plain)
                .textInputAutocapitalization(.never)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(RakuColors.secondaryBackground, lineWidth: 1)
                )
                .padding(.horizontal)

            Picker("Project Type", selection: $selectedType) {
                Text("GitHub").tag(ProjectType.github)
                Text("Binary").tag(ProjectType.binary)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            ColorPicker("Select Color", selection: $selectedColor)
                .padding(.horizontal)

            Spacer()

            Button(action: {
                saveProject()
                isSheetPresented = false
            }) {
                Text(editingProject == nil ? "Save" : "Update")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Button("Cancel") {
                isSheetPresented = false
            }
            .padding(.top, 10)
        }
        .padding()
        .onAppear {
            if let project = editingProject {
                projectName = project.name
                selectedType = project.type
                selectedColor = project.color
            }
        }
    }

    private func saveProject() {
        if let project = editingProject {
            // Update existing project
            projectManager.updateProject(project: project, name: projectName, color: selectedColor)
        } else {
            // Create a new project
            projectManager.createProject(name: projectName, type: selectedType, color: selectedColor)
        }
    }
}
