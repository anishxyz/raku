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
    @State private var selectedType: ProjectType = .binary
    @State private var selectedColor: Color = RakuColors.orange
    
    @Environment(\.modelContext) private var modelContext
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(spacing: 20) {
            Text(editingProject == nil ? "Add a New Project" : "Edit Project")
                .font(.headline)
            
            VStack {
                HStack {
                    if selectedType == ProjectType.github {
                        Text("Username")
                            .font(.headline)
                    } else {
                        Text("Name")
                            .font(.headline)
                    }

                    Spacer()
                    
                    TextField("", text: $projectName, prompt: Text("required"))
                        .multilineTextAlignment(.trailing)
                        .frame(alignment: .trailing)
                        .textInputAutocapitalization(.never)
                }
                
                if editingProject == nil {
                    HStack {
                        Text("Type")
                            .font(.headline)
                        
                        Spacer()
                        
                        TypeButton(
                            type: .binary,
                            text: "Binary",
                            isSelected: selectedType == .binary,
                            action: { selectedType = .binary }
                        )
                        
                        TypeButton(
                            type: .github,
                            text: "GitHub",
                            isSelected: selectedType == .github,
                            action: { selectedType = .github },
                            accentColor: RakuColors.githubGreen
                        )
                        
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
                    
                    HStack(spacing: 12) {
                        ForEach(RakuColorList, id: \.self) { color in
                            Button(action: {
                                generator.impactOccurred()
                                selectedColor = color
                            }) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Group {
                                            if selectedColor == color {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    )
                            }
                        }
                        
                        ColorPicker("Select Color", selection: $selectedColor)
                            .labelsHidden()
                            .frame(height: 24)
                    }
                }
            }
            .padding()
            .background(RakuColors.secondaryBackground)
            .cornerRadius(12)
            
            

            Spacer()
            
            HStack {
                Button(action: {
                    feedbackGenerator.notificationOccurred(.warning)
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
                    feedbackGenerator.notificationOccurred(.success)
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
                .disabled(projectName.isEmpty)
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


struct TypeButton: View {
    let type: ProjectType
    let text: String
    let isSelected: Bool
    let action: () -> Void
    let accentColor: Color
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    init(type: ProjectType, text: String, isSelected: Bool, action: @escaping () -> Void, accentColor: Color = RakuColors.accentColor) {
        self.type = type
        self.text = text
        self.isSelected = isSelected
        self.action = action
        self.accentColor = accentColor
    }

    var body: some View {
        Button {
            generator.impactOccurred()
            action()
        } label: {
           HStack {
//               if isSelected {
//                   Image(systemName: "checkmark")
//               }
               Text(text)
           }
           .padding(.horizontal, 12)
           .padding(.vertical, 6)
       }
       .background(isSelected ? accentColor : Color.clear)
       .foregroundColor(isSelected ? .white : accentColor)
       .overlay(
           RoundedRectangle(cornerRadius: 8)
               .stroke(accentColor, lineWidth: 1)
       )
       .cornerRadius(8)
    }
}
