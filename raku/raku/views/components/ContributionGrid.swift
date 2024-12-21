//
//  ContributionGrid.swift
//  raku
//
//  Created by Anish Agrawal on 12/20/24.
//

import SwiftUI

struct ContributionGrid: View {
    @Bindable var project: Project
    
    var body: some View {
        GeometryReader { geo in
            // The total width available
            let availableWidth = geo.size.width
            
            // Your chosen minimum column width
            let minColumnWidth: CGFloat = 14
            // Spacing between columns (if any)
            let spacing: CGFloat = 4
            
            // Figure out how many columns can fit:
            //  e.g. dividing the available width by
            //  (minColumnWidth + spacing).
            //  Then cap it at at least 1, to avoid 0.
            let columnsCount = max(
                Int((availableWidth + spacing) / (minColumnWidth + spacing)),
                1
            )
            
            // Now that we know how many columns, build them:
            let columns = Array(
                repeating: GridItem(.flexible(minimum: minColumnWidth), spacing: spacing),
                count: columnsCount
            )
            
            LazyVGrid(columns: columns) {
                // Use only as many items as you want to fetch:
                // for example, the first `columnsCount` items
                // or some multiple of `columnsCount`.
                ForEach(project.data.prefix(columnsCount), id: \.id) { item in
                    Text("\(item.title)")
                }
            }
        }
    }
}

