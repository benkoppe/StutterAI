//
//  Color-Extensions.swift
//  Assignment Tracker
//
//  Created by Ben K on 8/27/21.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}

public extension Color {
    
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)

    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondaryGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiaryGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    static let teal = Color(UIColor.systemTeal)
    
    

    // There are more..
}

func colorsEqual(_ lhs: Color, _ rhs: Color) -> Bool {
    func roundrgba(_ color: Color) -> (red: Double, blue: Double, green: Double, alpha: Double) {
        let rgba = UIColor(color).rgba
        return (round(rgba.red * 1000), round(rgba.blue * 1000), round(rgba.green * 1000), round(rgba.alpha * 1000))
    }
    
    if roundrgba(lhs) == roundrgba(rhs) {
        return true
    } else {
        return false
    }
}
