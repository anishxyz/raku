//
//  ColorUtils.swift
//  raku
//
//  Created by Anish Agrawal on 12/13/24.
//

import Foundation
import SwiftUI

struct _Color: Codable {
   var red: Float
   var green: Float
   var blue: Float
   var opacity: Float
}


func extractColorComponents(from color: Color) -> _Color {
    let uiColor = UIColor(color)
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var o: CGFloat = 0

    uiColor.getRed(&r, green: &g, blue: &b, alpha: &o)

    return _Color(
        red: Float(r),
        green: Float(g),
        blue: Float(b),
        opacity: Float(o)
    )
}
