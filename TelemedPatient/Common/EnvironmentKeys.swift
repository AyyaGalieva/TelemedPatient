//
//  EnvironmentKeys.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 09.12.2020.
//

import SwiftUI

// MARK: - Keys

struct KeyboardTypeKey: EnvironmentKey {
    static let defaultValue: UIKeyboardType = .default
}

struct AutocapitalizationKey: EnvironmentKey {
    static let defaultValue: UITextAutocapitalizationType = .sentences
}

struct TextContentTypeKey: EnvironmentKey {
    static let defaultValue: UITextContentType? = nil
}

struct FloatingTextFieldInputTypeKey: EnvironmentKey {
    static let defaultValue: FloatingTextFieldInputType = .text
}

// MARK: - Keys values

extension EnvironmentValues {
    
    var keyboardType: UIKeyboardType {
        get {
            return self[KeyboardTypeKey.self]
        }
        set {
            self[KeyboardTypeKey.self] = newValue
        }
    }
    
    var autocapitalization: UITextAutocapitalizationType {
        get {
            return self[AutocapitalizationKey.self]
        }
        set {
            self[AutocapitalizationKey.self] = newValue
        }
    }
    
    var textContentType: UITextContentType? {
        get {
            return self[TextContentTypeKey.self]
        }
        set {
            self[TextContentTypeKey.self] = newValue
        }
    }
    
    var floatingTextFieldInputType: FloatingTextFieldInputType {
        get {
            return self[FloatingTextFieldInputTypeKey.self]
        }
        set {
            self[FloatingTextFieldInputTypeKey.self] = newValue
        }
    }
}
