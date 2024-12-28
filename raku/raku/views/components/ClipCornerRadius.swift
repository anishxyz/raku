//
//  CustomCornerRadiusShape.swift
//  raku
//
//  Created by Anish Agrawal on 12/25/24.
//

import Foundation
import SwiftUI

struct ClipCornerRadius: Shape {
    let topLeft: CGFloat
    let topRight: CGFloat
    let bottomLeft: CGFloat
    let bottomRight: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start from top left
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        
        // Top right corner
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
                    radius: topRight,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        // Bottom right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
                    radius: bottomRight,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        // Bottom left corner
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
                    radius: bottomLeft,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        // Top left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
                    radius: topLeft,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        return path
    }
}


extension View {
    func clipCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(
            ClipCornerRadius(
                topLeft: corners.contains(.topLeft) ? radius : 0,
                topRight: corners.contains(.topRight) ? radius : 0,
                bottomLeft: corners.contains(.bottomLeft) ? radius : 0,
                bottomRight: corners.contains(.bottomRight) ? radius : 0
            )
        )
    }
}
