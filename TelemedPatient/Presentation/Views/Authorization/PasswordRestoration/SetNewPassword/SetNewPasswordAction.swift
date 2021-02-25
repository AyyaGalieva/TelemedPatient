//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum SetNewPasswordAction: Equatable {
    case newPasswordChanged(_ newPassword: String)
    case newPasswordConfirmationChanged(_ newPasswordConfirmation: String)
    case setNewPasswordButtonTapped
//    case setNewPasswordResponse(_ response: Result<SetNewPasswordResponse, ResetPasswordAPI.Error>)
    case alertDismissed
    case validate
}

extension SetNewPasswordAction {

    static func view(_ localAction: SetNewPasswordView.ViewAction) -> Self {
        switch localAction {
        case .setNewPasswordButtonTapped:
            return .setNewPasswordButtonTapped
        case let .newPasswordChanged(newPassword):
            return .newPasswordChanged(newPassword)
        case let .newPasswordConfirmationChanged(newPasswordConfirmation):
            return .newPasswordConfirmationChanged(newPasswordConfirmation)
        case .validate:
            return .validate
        }
    }
}
