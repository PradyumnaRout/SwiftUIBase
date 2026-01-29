//
//  UIFont+Extensions.swift
//  MVVMBaseProject
//
//  Created by hb on 12/07/23.
//

import Foundation
import UIKit
import SwiftUICore

extension UIFont {
    
    enum FontWeight: String {
        case Black = "Inter-Black"
        case Bold = "Inter-Bold"
        case ExtraBold = "Inter-ExtraBold"
        case ExtraLight = "Inter-ExtraLight"
        case Light = "Inter-Light"
        case Medium = "Inter-Medium"
        case Regular = "Inter-Regular"
        case SemiBold = "Inter-SemiBold"
        case Thin = "Inter-Thin"
        
    }
    
    class func Inter(size: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func printFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
    
    enum RobotoFontWeight: String {
        case Black = "Roboto-Black"
        case BlackItalic = "Roboto-BlackItalic"
        case Bold = "Roboto-Bold"
        case BoldItalic = "Roboto-BoldItalic"
        case Italic = "Roboto-Italic"
        case Light = "Roboto-Light"
        case LightItalic = "Roboto-LightItalic"
        case Medium = "Roboto-Medium"
        case MediumItalic = "Roboto-MediumItalic"
        case Regular = "Roboto-Regular"
        case Thin = "Roboto-Thin"
        case ThinItalic = "Roboto-ThinItalic"
    }
    
    class func Roboto(size: CGFloat, weight: RobotoFontWeight) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
