//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum ResetPasswordAction: Equatable {
    case emailChanged(_ email: String)
    case restorationButtonTapped
    case alertDismissed
    case sendEmailResponse(_ response: Result<ResetPasswordResponse, ResetPasswordAPI.Error>)
}

extension ResetPasswordAction {

    static func view(_ localAction: ResetPasswordView.ViewAction) -> Self {
        switch localAction {
        case let .emailChanged(email):
            return .emailChanged(email)
        case .restorationButtonTapped:
            return .restorationButtonTapped
        }
    }
}
