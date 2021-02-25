//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct SetNewPasswordState: Equatable {
    var newPassword = ""
    var newPasswordConfirmation = ""
    var isFormValid = false
    var isSetNewPasswordRequestPerformed = false
    var alert: AlertState<SetNewPasswordAction>?
}

extension SetNewPasswordState {

    var view: SetNewPasswordView.ViewState {
        SetNewPasswordView.ViewState(newPassword: newPassword,
                newPasswordConfirmation: newPasswordConfirmation,
                isFormValid: isFormValid,
                isActivityIndicatorVisible: isSetNewPasswordRequestPerformed,
                isUserInteractionDisabled: isSetNewPasswordRequestPerformed,
                isSetNewPasswordButtonDisabled: !isFormValid)
    }
}
