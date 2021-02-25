//
//  Color+Extensions.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 16.11.2020.
//

import SwiftUI
import Hue

extension Color {
    
    init(hex: String) {
        self = Color(UIColor(hex: hex))
    }
    
    init(_ uiColor: UIColor?) {
        self = uiColor == nil ? .white : Color(uiColor!)
    }
}
