//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

let signUpReducer = Reducer<SignUpState, SignUpAction, SignUpEnvironment> { state, action, environment in
    switch action {
    case .emailChanged(let email):
        state.email = email
        return .none
    case .passwordChanged(let password):
        state.password = password
        return .none
    case .fioChanged(let fio):
        state.fio = fio
        return .none
    case .phoneChanged(let phone):
        state.phone = phone
        return .none
    case .signUpButtonTapped:
        state.isSignUpRequestPerformed = true
        return environment.authorizationClient
                .signUp(SignUpRequest(email: state.email, password: state.password, fio: state.fio, phone: state.phone))
                .receive(on: environment.mainQueue)
                .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                .catchToEffect()
                .map(SignUpAction.signUpResponse) // TODO think about change isLoginRequestPerformed to false here
    case .alertDismissed:
        state.alert = nil
        return .none
    case let .signUpResponse(.success(response)):
        state.isSignUpRequestPerformed = false
        return .none
    case let .signUpResponse(.failure(error)):
        state.alert = .init(title: .init(error.localizedDescription))
        state.isSignUpRequestPerformed = false
        return .none
    case .validate:
        state.validationState.validte(state.fio, phone: state.phone, email: state.email)
        return .none
    }
}
