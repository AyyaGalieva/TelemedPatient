//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum SignUpAction: Equatable {
    case fioChanged(_ fio: String)
    case phoneChanged(_ phone: String)
    case emailChanged(_ email: String)
    case passwordChanged(_ password: String)
    case signUpButtonTapped
    case signUpResponse(_ response: Result<AuthorizationResponse, AuthorizationAPI.Error>)
    case alertDismissed
    case validate
}

extension SignUpAction {

    static func view(_ localAction: SignUpView.ViewAction) -> Self {
        switch localAction {
        case let .fioChanged(fio):
            return .fioChanged(fio)
        case let .phoneChanged(phone):
            return .phoneChanged(phone)
        case let .emailChanged(email):
            return .emailChanged(email)
        case let .passwordChanged(password):
            return .passwordChanged(password)
        case .signUpButtonTapped:
            return .signUpButtonTapped
        case .validate:
            return .validate
        }
    }
}