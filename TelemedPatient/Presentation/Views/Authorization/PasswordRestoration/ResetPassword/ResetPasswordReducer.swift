//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

var resetPasswordReducer = Reducer<ResetPasswordState, ResetPasswordAction, ResetPasswordEnvironment> { state, action, environment in
    switch action {
    case .emailChanged(let email):
        state.email = email
        return .none
    case .restorationButtonTapped:
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment.resetPasswordClient
                        .sendEmail(SendEmailRequest(data: SendEmailData(email: state.email, role: "ROLE_PATIENT")))
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(ResetPasswordAction.sendEmailResponse)
        )
    case .alertDismissed:
        state.alert = nil
        return .none
    case .sendEmailResponse(let result):
        switch result {
        case .success:
            state.alert = .init(title: .init(R.string.localizable.messagesCheckEmail()))
        case .failure(let error):
            state.alert = .init(title: .init(error.localizedDescription))
        }

        return environment.progressHUD.dismiss().fireAndForget()
    }
}
