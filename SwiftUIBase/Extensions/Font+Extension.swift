//
//  Font+Extension.swift
//  MVVMBaseProject
//
//  Created by hb on 22/04/25.
//

import SwiftUI

extension Font {
    static func sulphurFont(weight: SulphurFontWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

/// Light = 300
/// Regular = 400
/// Bold = 700
enum SulphurFontWeight: String {
    case Light = "SulphurPoint-Light"
    case Regular = "SulphurPoint-Regular"
    case Bold = "SulphurPoint-Bold"
}
