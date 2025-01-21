//
//  ColorConstants.swift
//  raku
//
//  Created by Anish Agrawal on 12/6/24.
//

import Foundation
import SwiftUI

struct RakuColors {
    static let secondaryBackground = Color(.systemGray6)
    static let tertiaryBackground = Color.gray.opacity(0.3)
    static let quaternaryBackground = Color.gray.opacity(0.15)
    static let lightModeGray6 = Color(UIColor { traits in
        return traits.userInterfaceStyle == .dark ? .systemGray6 : .systemGray6
    }.resolvedColor(with: .init(userInterfaceStyle: .light)))

    
    static let githubGreen = Color(red: 40/255, green: 190/255, blue: 69/255, opacity: 1)
    static let blue = Color.blue
    static let orange = Color(red: 255/255, green: 103/255, blue: 0/255, opacity: 1)
    static let purple = Color(red: 97/255, green: 61/255, blue: 193/255, opacity: 1)
    static let ferrariRed = Color(red: 255/255, green: 40/255, blue: 0/255, opacity: 1)
    
    static let accentColor = Color(red: 255/255, green: 103/255, blue: 0/255, opacity: 1)
}

var RakuColorList: [Color] {
    [RakuColors.blue, RakuColors.orange, RakuColors.purple, RakuColors.ferrariRed, RakuColors.githubGreen]
}
