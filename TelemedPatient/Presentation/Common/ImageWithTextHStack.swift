//
//  ImageWithTextHStack.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 18.01.2021.
//

import SwiftUI

struct ImageWithTextHStack: View {
    
    private struct Constants {
        static let buttonImageEdge: CGFloat = 24
    }
    
    var uiImage: UIImage?
    var text: String
    
    var body: some View {
        HStack(spacing: 5) {
            if let uiImage = uiImage {
                Image(uiImage)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: Constants.buttonImageEdge,
                           height: Constants.buttonImageEdge)
            }
            
            Text(text)
                .textCase(.uppercase)
        }
    }
}
