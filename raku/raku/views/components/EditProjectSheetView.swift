//
//  EditProjectSheetView.swift
//  raku
//
//  Created by Anish Agrawal on 1/22/25.
//

import SwiftUI

struct EditProjectSheetView: View {
    @Binding var isPresented: Bool
    @Binding var editingProject: Project?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color.black
                    .ignoresSafeArea()
            }
            ProjectEditor(isSheetPresented: $isPresented, editingProject: $editingProject)
                .presentationDetents([.medium])
        }
    }
}
