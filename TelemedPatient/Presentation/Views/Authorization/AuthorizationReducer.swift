//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

let authorizationReducer = Reducer<AuthorizationState, AuthorizationAction, AuthorizationEnvironment>.combine(
        loginReducer.optional().pullback(
                state: \.loginState,
                action: /AuthorizationAction.login,
                environment: {
                    LoginEnvironment(authorizationClient: $0.authorizationClient,
                            resetPasswordClient: $0.resetPasswordClient,
                            mainQueue: $0.mainQueue,
                            progressHUD: $0.progressHUD
                    )
                }),
        signUpReducer.optional().pullback(
                state: \.signUpState,
                action: /AuthorizationAction.signUp,
                environment: {
                    SignUpEnvironment(authorizationClient: $0.authorizationClient,
                            mainQueue: $0.mainQueue,
                            progressHUD: $0.progressHUD
                    )
                }),
        Reducer<AuthorizationState, AuthorizationAction, AuthorizationEnvironment>({ state, action, environment in
            switch action {
            case .switchMode:
                switch state.mode {
                case .login:
                    state.mode = .signUp(SignUpState())
                case .signUp:
                    state.mode = .login(LoginState())
                }
                return .none
            case .login(.loginResponse(.success(let response))),
                 .signUp(.signUpResponse(.success(let response))):
                return Effect(value: AuthorizationAction.authorized(response.token, profile: response.patientProfile))
            default:
                return .none
            }
        })
)
