//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

struct AuthorizationState: Equatable {

    enum Mode: Equatable {
        case login(_ loginState: LoginState)
        case signUp(_ signUpState: SignUpState)
    }

    var mode: Mode
    var doctorProfile: DoctorProfile
}

extension AuthorizationState {
    var loginState: LoginState? {
        get {
            if case let Mode.login(loginState) = mode {
                return loginState
            }

            return nil
        }
        set {
            mode = .login(newValue ?? LoginState()) //TODO think about this
        }
    }

    var signUpState: SignUpState? {
        get {
            if case let Mode.signUp(signUpState) = mode {
                return signUpState
            }

            return nil
        }
        set {
            mode = .signUp(newValue ?? SignUpState()) //TODO think about this
        }
    }
}
