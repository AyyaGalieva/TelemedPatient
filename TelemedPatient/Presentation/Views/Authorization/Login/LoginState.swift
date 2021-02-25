//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct LoginState: Equatable {
    var email = ""
    var isEmailValid = false
    var password = ""
    var isFormValid = false
    var alert: AlertState<LoginAction>?
    var sendEmailState: ResetPasswordState? = ResetPasswordState()
}

extension LoginState {

    var view: LoginView.ViewState {
        LoginView.ViewState(email: email,
                isEmailValid: isEmailValid,
                password: password,
                isLoginButtonDisabled: !isFormValid)
    }
}
