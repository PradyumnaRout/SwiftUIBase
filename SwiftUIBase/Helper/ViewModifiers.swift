//
//  ViewModifiers.swift
//  SwiftUIBase
//
//  Created by hb on 30/01/26.
//

import SwiftUI

// MARK: Alert Text Modifier

struct alertTextStyle: ViewModifier {
    var font: Font
    var foregroundColor: Color
    var textAlignment: TextAlignment
    var paddingTop: CGFloat
    var paddingBottom: CGFloat
    var paddingHorizontal: CGFloat
    var fixedHorizontally: Bool = false
    var fixedVertically: Bool = true
    
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(foregroundColor)
            .multilineTextAlignment(textAlignment)
            .padding(.top, paddingTop)
            .padding(.bottom, paddingBottom)
            .padding(.horizontal, paddingHorizontal)
            .fixedSize(horizontal: fixedHorizontally, vertical: fixedVertically)
        // Expand vertically
        // horizontally it will not expand beyond the available space. But can squeez/compress horizontally.
    }
}


extension View {
    func alertStyle(
        font: Font,
        foregroundColor: Color,
        textAlignment: TextAlignment,
        paddingTop: CGFloat,
        paddingBottom: CGFloat,
        paddingHorizontal: CGFloat
    ) -> some View {
        self
            .modifier(
                alertTextStyle(
                    font: font,
                    foregroundColor: foregroundColor,
                    textAlignment: textAlignment,
                    paddingTop: paddingTop,
                    paddingBottom: paddingBottom,
                    paddingHorizontal: paddingHorizontal
                )
            )
    }
}
