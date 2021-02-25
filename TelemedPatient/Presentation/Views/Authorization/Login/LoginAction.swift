//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum LoginAction: Equatable {
    case emailChanged(_ email: String)
    case passwordChanged(_ password: String)
    case loginButtonTapped
    case loginResponse(_ response: Result<AuthorizationResponse, AuthorizationAPI.Error>)
    case alertDismissed
    case sendEmail(_ sendEmailAction: ResetPasswordAction)
    case validate
}

extension LoginAction {

    static func view(_ localAction: LoginView.ViewAction) -> Self {
        switch localAction {
        case let .emailChanged(email):
            return .emailChanged(email)
        case .loginButtonTapped:
            return .loginButtonTapped
        case let .passwordChanged(password):
            return .passwordChanged(password)
        case .validate:
            return .validate
        }
    }
}
