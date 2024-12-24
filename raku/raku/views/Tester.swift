//
//  Tester.swift
//  raku
//
//  Created by Anish Agrawal on 12/11/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct ColorStepsView: View {
    let baseGreen = Color(red: 0, green: 0.8, blue: 0)
    
    var body: some View {
        HStack(spacing: 8) {
//            RoundedRectangle(cornerRadius: 4)
//                .fill(RakuColors.githubGreen)
//                .saturation(0.75)
//                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(baseGreen)
                .saturation(0.25)
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(baseGreen)
                .saturation(0.5)
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(baseGreen)
                .saturation(0.75)
                .frame(width: 20, height: 20)
            RoundedRectangle(cornerRadius: 4)
                .fill(baseGreen)
                .saturation(1)
                .frame(width: 20, height: 20)
        }
    }
}


#Preview {
    ColorStepsView()
}
