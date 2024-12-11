//
//  tester.swift
//  raku
//
//  Created by Anish Agrawal on 12/11/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct ColorStepsView: View {
    var body: some View {
        HStack(spacing: 8) {
//            RoundedRectangle(cornerRadius: 4)
//                .fill(RakuColors.githubGreen)
//                .saturation(0.75)
//                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(RakuColors.githubGreen)
                .saturation(1)
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(RakuColors.githubGreen)
                .saturation(2)
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(RakuColors.githubGreen)
                .saturation(3)
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(RakuColors.githubGreen)
                .saturation(4)
                .frame(width: 20, height: 20)
        }
    }
}


#Preview {
    ColorStepsView()
}
