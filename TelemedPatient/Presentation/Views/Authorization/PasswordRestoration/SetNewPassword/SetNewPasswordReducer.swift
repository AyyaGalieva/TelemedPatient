//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

var setNewPasswordReducer = Reducer<SetNewPasswordState, SetNewPasswordAction, SetNewPasswordEnvironment> { state, action, environment in
    switch action {
    case .newPasswordChanged(let newPassword):
        state.newPassword = newPassword
        return .none
    case .newPasswordConfirmationChanged(let newPasswordConfirmation):
        state.newPasswordConfirmation = newPasswordConfirmation
        return .none
    case .setNewPasswordButtonTapped:
        state.isSetNewPasswordRequestPerformed = true
        return .none
//        return environment.resetPasswordClient
//                .login(LoginRequest(email: state.email, password: state.password))
//                .receive(on: environment.mainQueue)
//                .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
//                .catchToEffect()
//                .map(LoginAction.loginResponse) // TODO think about change isLoginRequestPerformed to false here
    case .alertDismissed:
        state.alert = nil
        return .none
//    case let .setNewPasswordResponse(.success(response)):
//        state.isSetNewPasswordRequestPerformed = false
//        return .none
//    case let .setNewPasswordResponse(.failure(error)):
//        state.alert = .init(title: .init(error.localizedDescription))
//        state.isSetNewPasswordRequestPerformed = false
//        return .none
    case .validate:
        state.isFormValid = (state.newPassword == state.newPasswordConfirmation)
        return .none
    }
}
