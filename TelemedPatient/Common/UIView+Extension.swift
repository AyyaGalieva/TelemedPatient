//
//  UIResponder+Extension.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 27.11.2020.
//

import SwiftUI

extension UIView {
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
