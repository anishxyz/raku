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
        VStack {
            BulletCalendarView(project: project)
                .padding()
        }
    }
}
