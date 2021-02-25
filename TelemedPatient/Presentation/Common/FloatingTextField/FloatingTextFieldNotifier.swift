//
//  FloatingTextFieldNotifier.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 22.12.2020.
//

import SwiftUI

enum FloatingTextFieldBorderType {
    
    case roundedRectangle
    case bottomLine
}

enum FloatingTextFieldInputType {
    
    case text
    case date
    case image
}

class FloatingTextFieldNotifier: ObservableObject {
    
    @Published var isSecureTextField: Bool = false
    
    @Published var maskType: MaskType? = nil
    
    @Published var leftImage: Image? = nil
    
    @Published var borderType: FloatingTextFieldBorderType = .roundedRectangle
    
    @Published var keyboardType: UIKeyboardType = .default
    
    @Published var autocapitalization: UITextAutocapitalizationType = .sentences
    
    @Published var textContentType: UITextContentType? = nil
    
    @Published var inputType: FloatingTextFieldInputType = .text
}

