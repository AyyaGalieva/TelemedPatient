//
//  View+Extensions.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 26.11.2020.
//

import SwiftUI

extension View {
    
    func animatableSystemFont(size: CGFloat,
                              weight: Font.Weight = .regular,
                              design: Font.Design = .default) -> some View {
        modifier(AnimatableSystemFontModifier(size: size,
                                              weight: weight,
                                              design: design))
    }
}
