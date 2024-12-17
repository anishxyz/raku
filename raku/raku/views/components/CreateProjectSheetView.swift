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
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 20) {
            Text(editingProject == nil ? "Add a New Project" : "Edit Project")
                .font(.headline)
            
            VStack {
                HStack {
                    Text("Name")
                        .font(.headline)
                    
                    Spacer()
                    
                    TextField("", text: $projectName)
                        .multilineTextAlignment(.trailing)
                        .frame(alignment: .trailing)
                        .textInputAutocapitalization(.never)
                }
                
                if editingProject == nil {
                    HStack {
                        Text("Type")
                            .font(.headline)
                        
                        Spacer()
                        
                        Picker("Type", selection: $selectedType) {
                            Text("GitHub").tag(ProjectType.github)
                            Text("Binary").tag(ProjectType.binary)
                        }
                        .frame(height: 18)
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 0)
                    }
                    .padding(.top)
                }
            }
            .padding()
            .background(RakuColors.secondaryBackground)
            .cornerRadius(12)
            
            VStack {
                HStack {
                    Text("Color")
                        .font(.headline)
                    
                    Spacer()
                    
                    ColorPicker("Select Color", selection: $selectedColor)
                        .labelsHidden()
                        .frame(height: 18)
                }
            }
            .padding()
            .background(RakuColors.secondaryBackground)
            .cornerRadius(12)
            
            

            Spacer()
            
            HStack {
                Button(action: {
                    isSheetPresented = false
                }) {
                    Text("Cancel")
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                                
                Button(action: {
                    saveProject()
                    isSheetPresented = false
                }) {
                    Text(editingProject == nil ? "Save" : "Update")
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                }
                .buttonStyle(.bordered)
                .tint(.orange)
            }
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
            project.name = projectName
            project._color = extractColorComponents(from: selectedColor)
        } else {
            // Create a new project
            let new_project = Project(name: projectName, type: selectedType, color: selectedColor)
            modelContext.insert(new_project)
        }
        try? modelContext.save()
    }
}


#Preview { @MainActor in
    ProjectsView()
        .modelContainer(previewContainer)
}
