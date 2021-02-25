//
//  AnimatableModifiers.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 26.11.2020.
//

import SwiftUI


struct AnimatableSystemFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight
    var design: Font.Design

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}
