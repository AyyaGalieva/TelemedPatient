//
// Created by Андрей Кривобок on 19.11.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    struct ViewState: Equatable {
        var fio: String
        var phone: String
        var email: String
        var password: String
        var validationState: SignUpValidationState
    }

    enum ViewAction {
        case fioChanged(_ fio: String)
        case phoneChanged(_ phone: String)
        case emailChanged(_ email: String)
        case passwordChanged(_ password: String)
        case signUpButtonTapped
        case validate
    }

    let store: Store<SignUpState, SignUpAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0.view }, action: SignUpAction.view)) { viewStore in
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    FloatingTextField(
                        R.string.localizable.authorizationFullName(),
                        text: viewStore.binding(get: { $0.fio }, send: ViewAction.fioChanged),
                        errorText: .constant(R.string.localizable.errorsWrongFullName()),
                        isValid: viewStore.validationState.isFullNameValid,
                        onEditingChanged: { isEditing in
                            guard !isEditing else { return }
                            viewStore.send(.validate)
                        }
                    ).autocapitalization(.none)

                    FloatingTextField(
                        R.string.localizable.authorizationPhone(),
                        text: viewStore.binding(get: { $0.phone }, send: ViewAction.phoneChanged),
                        errorText: .constant(R.string.localizable.errorsWrongPhone()),
                        isValid: viewStore.validationState.isPhoneValid,
                        onEditingChanged: { isEditing in
                            guard !isEditing else { return }
                            viewStore.send(.validate)
                        }
                    ).autocapitalization(.none)
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                        .maskType(.phone)
                    
                    FloatingTextField(
                        R.string.localizable.authorizationEmail(),
                        text: viewStore.binding(get: { $0.email }, send: ViewAction.emailChanged),
                        errorText: .constant(R.string.localizable.errorsWrongEmail()),
                        isValid: viewStore.validationState.isEmailValid,
                        onEditingChanged: { isEditing in
                            guard !isEditing else { return }
                            viewStore.send(.validate)
                        }
                    ).autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)


                    FloatingTextField(
                            R.string.localizable.authorizationPassword(),
                            text: viewStore.binding(get: { $0.password }, send: ViewAction.passwordChanged)
                    ).autocapitalization(.none)
                        .textContentType(.password)
                        .isSecureTextField(true)
                }

                Button(R.string.localizable.authorizationSignIn()) {
                    viewStore.send(.signUpButtonTapped)
                }.buttonStyle(TelemedButtonStyle())
                .padding(.top, 20)
                .disabled(!viewStore.validationState.isFormValid)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(store: Store<SignUpState, SignUpAction>(initialState: SignUpState(fio: "", phone: "", email: "", password: ""),
                reducer: signUpReducer, environment: SignUpEnvironment(authorizationClient: .live, mainQueue: DispatchQueue.main.eraseToAnyScheduler(), progressHUD: ProgressHUDPresenter())))
    }
}
