//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct ResetPasswordState: Equatable {
    var email = ""
    var isFormValid = false
    var alert: AlertState<ResetPasswordAction>?
    var showView: Bool = false
}

extension ResetPasswordState {

    var view: ResetPasswordView.ViewState {
        ResetPasswordView.ViewState(email: email,
                isRestorationButtonDisabled: !isFormValid)
    }
}
