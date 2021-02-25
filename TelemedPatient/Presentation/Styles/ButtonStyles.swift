//
//  ButtonStyles.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 26.11.2020.
//

import SwiftUI

struct TelemedButtonStyle: ButtonStyle {
    
    internal init(backgroundColor: UIColor? = R.color.cornflowerBlue()) {
        self.backgroundColor = backgroundColor
    }    
    
    var backgroundColor: UIColor?
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 15).weight(.bold))
            .frame(maxWidth: CGFloat.infinity)
            .padding()
            .background(Color(backgroundColor))
            .cornerRadius(10)
            .foregroundColor(Color.white)
    }
}
