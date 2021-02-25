//
//  SetNewPasswordView.swift
//  TelemedPatient
//
//  Created by Galieva on 10.12.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SetNewPasswordView: View {
    
    struct ViewState: Equatable {
        var newPassword: String
        var newPasswordConfirmation: String
        var isFormValid: Bool
        var isActivityIndicatorVisible: Bool
        var isUserInteractionDisabled: Bool
        var isSetNewPasswordButtonDisabled: Bool
    }

    enum ViewAction {
        case newPasswordChanged(_ password: String)
        case newPasswordConfirmationChanged(_ password: String)
        case setNewPasswordButtonTapped
        case validate
    }

    let store: Store<SetNewPasswordState, SetNewPasswordAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0.view }, action: SetNewPasswordAction.view)) { viewStore in
            VStack() {
                VStack(spacing: 10) {
                    Text(R.string.localizable.authorizationEnterNewPassword())
                        .foregroundColor(Color(R.color.blackLabel()))
                        .font(.system(size: 20))
                        .fontWeight(.thin)
                    
                    FloatingTextField(
                            R.string.localizable.authorizationNewPassword(),
                            text: viewStore.binding(get: { $0.newPassword }, send: ViewAction.newPasswordChanged)
                    ).autocapitalization(.none)
                        .textContentType(.password)
                        .isSecureTextField(true)
                    
                    FloatingTextField(
                        R.string.localizable.authorizationPasswordConfirmation(),
                        text: viewStore.binding(
                            get: { $0.newPasswordConfirmation },
                            send: ViewAction.newPasswordConfirmationChanged
                        ),
                        errorText: .constant(R.string.localizable.errorsPasswordsDoNotMatch()),
                        isValid: viewStore.isFormValid,
                        onEditingChanged: { isEditing in
                            guard !isEditing else { return }
                            viewStore.send(.validate)
                        }
                    ).autocapitalization(.none)
                        .textContentType(.password)
                        .isSecureTextField(true)
                }

                Spacer().frame(height: 20)

                Button(R.string.localizable.authorizationConfirm()) {
                    viewStore.send(.setNewPasswordButtonTapped)
                }
                .buttonStyle(TelemedButtonStyle())
                .padding(.top, 20)
                .disabled(viewStore.isSetNewPasswordButtonDisabled)
            }
                    .alert(self.store.scope(state: { $0.alert }), dismiss: .alertDismissed)
        }
    }

}

struct SetNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SetNewPasswordView(store: Store<SetNewPasswordState, SetNewPasswordAction>(
                    initialState: SetNewPasswordState(newPassword: "", newPasswordConfirmation: "", isFormValid: false, isSetNewPasswordRequestPerformed: false, alert: nil),
                    reducer: setNewPasswordReducer, environment: SetNewPasswordEnvironment(resetPasswordClient: .live, mainQueue: DispatchQueue.main.eraseToAnyScheduler())))
            .previewLayout(.sizeThatFits)
    }
}
