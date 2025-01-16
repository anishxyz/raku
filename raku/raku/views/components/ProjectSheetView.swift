//
//  ProjectSheetView.swift
//  raku
//
//  Created by Anish Agrawal on 1/16/25.
//

import SwiftUI
import Foundation

struct ProjectSheetView: View {
    
    @Binding var selectedProject: Project?
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        VStack {
            if let project = selectedProject {
                ScrollView(.vertical) {
                    BulletCalendarView(project: project)
                        .padding()
                }
            } else {
                Text("Not found")
            }

        }
    }
}
