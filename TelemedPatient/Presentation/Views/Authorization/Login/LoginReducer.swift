//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

var loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment>.combine(
        resetPasswordReducer.optional().pullback(
                state: \.sendEmailState,
                action: /LoginAction.sendEmail,
                environment: {
                    ResetPasswordEnvironment(resetPasswordClient: $0.resetPasswordClient, mainQueue: $0.mainQueue, progressHUD: $0.progressHUD)
                }),
        Reducer<LoginState, LoginAction, LoginEnvironment>({ state, action, environment in
            switch action {
            case .emailChanged(let email):
                state.email = email
                return .none
            case .passwordChanged(let password):
                state.password = password
                return .none
            case .loginButtonTapped:
                return Effect.concatenate(
                        environment.progressHUD.show().fireAndForget(),
                        environment.authorizationClient
                                .login(LoginRequest(email: state.email, password: state.password))
                                .receive(on: environment.mainQueue)
                                .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                                .catchToEffect()
                                .map(LoginAction.loginResponse)
                )
            case .alertDismissed:
                state.alert = nil
                return .none
            case let .loginResponse(result):
                switch result {
                case .success: break
                case .failure(let error):
                    state.alert = .init(title: .init(error.localizedDescription))
                }
                return environment.progressHUD.dismiss().fireAndForget()
            case .validate:
                state.isEmailValid = state.email.isEmail
                state.isFormValid = state.isEmailValid
                return .none
            default:
                return .none
            }
        })
)
