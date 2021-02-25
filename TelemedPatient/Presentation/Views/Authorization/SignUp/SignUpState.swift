//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct SignUpValidationState: Equatable {

    var isFullNameValid = false
    var isPhoneValid = false
    var isEmailValid = false

    mutating func validte(_ fullName: String, phone: String, email: String) {
        isFullNameValid = fullName.isFullName
        isPhoneValid = phone.isPhone
        isEmailValid = email.isEmail
    }

    var isFormValid: Bool {
        return isFullNameValid && isPhoneValid && isEmailValid
    }
}

struct SignUpState: Equatable {
    var fio = ""
    var phone = ""
    var email = ""
    var password = ""
    var validationState = SignUpValidationState()
    var isSignUpRequestPerformed = false
    var alert: AlertState<SignUpAction>?
}

extension SignUpState {

    var view: SignUpView.ViewState {
        SignUpView.ViewState(fio: fio, phone: phone, email: email, password: password, validationState: validationState)
    }
}
