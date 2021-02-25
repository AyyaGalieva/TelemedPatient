//
// Created by Андрей Кривобок on 19.11.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @State var showResetPasswordView = false
    
    struct ViewState: Equatable {
        var email: String
        var isEmailValid: Bool
        var password: String
        var isLoginButtonDisabled: Bool
    }

    enum ViewAction {
        case emailChanged(_ email: String)
        case passwordChanged(_ password: String)
        case loginButtonTapped
        case validate
    }

    let store: Store<LoginState, LoginAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0.view }, action: LoginAction.view)) { viewStore in
            VStack() {
                VStack(spacing: 10) {
                    FloatingTextField(
                        R.string.localizable.authorizationEmail(),
                        text: viewStore.binding(
                            get: { $0.email },
                            send: ViewAction.emailChanged
                        ),
                        errorText: .constant(R.string.localizable.errorsWrongEmail()),
                        isValid: viewStore.isEmailValid,
                        onEditingChanged: { isEditing in
                            guard !isEditing else { return }
                            viewStore.send(.validate)
                        }
                    ).keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)

                    VStack(alignment: .leading, spacing: 10) {
                        FloatingTextField(
                            R.string.localizable.authorizationPassword(),
                            text: viewStore.binding(
                                get: { $0.password },
                                send: ViewAction.passwordChanged
                            )
                        ).autocapitalization(.none)
                        .textContentType(.password)
                        .isSecureTextField(true)

                        VStack {
                            IfLetStore(store.scope(state: { $0.sendEmailState },
                                           action: LoginAction.sendEmail)) { store in
                                NavigationLink(destination: ResetPasswordView(showResetPasswordView: self.$showResetPasswordView, store: store), isActive: self.$showResetPasswordView) {
                                    Text(R.string.localizable.authorizationLostPassword()).underline()
                                                            .foregroundColor(Color(R.color.cornflowerBlue()))
                                }
                            }
                        }
                    }
                }

                Spacer().frame(height: 20)

                Button(R.string.localizable.authorizationSignIn()) {
                    viewStore.send(.loginButtonTapped)
                }
                .buttonStyle(TelemedButtonStyle())
                .padding(.top, 20)
                .disabled(viewStore.isLoginButtonDisabled)
            }
                    .alert(self.store.scope(state: { $0.alert }), dismiss: .alertDismissed)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: Store<LoginState, LoginAction>(
                    initialState: LoginState(email: "", password: "", isFormValid: false, alert: nil),
                    reducer: loginReducer,
                environment: LoginEnvironment(authorizationClient: .live,
                        resetPasswordClient: .live,
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        progressHUD: ProgressHUDPresenter()))
        )
            .previewLayout(.sizeThatFits)
    }
}
