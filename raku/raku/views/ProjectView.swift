//
//  ProjectView.swift
//  raku
//
//  Created by Anish Agrawal on 12/5/24.
//

import Foundation
import SwiftUI


struct ProjectView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.headline)
            Text("Type: \(project.type.rawValue.capitalized)")
                .font(.subheadline)
            Text("Created At: \(project.created_at.formatted(date: .numeric, time: .omitted))")
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(RakuColors.secondaryBackground))
        .cornerRadius(24)
    }
}
