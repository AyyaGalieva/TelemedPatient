//
//  SendEmailView.swift
//  TelemedPatient
//
//  Created by Galieva on 04.12.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ResetPasswordView: View {
    @Binding var showResetPasswordView : Bool

    struct ViewState: Equatable {
        var email: String
        var isRestorationButtonDisabled: Bool
    }

    enum ViewAction {
        case emailChanged(_ email: String)
        case restorationButtonTapped
    }

    let store: Store<ResetPasswordState, ResetPasswordAction>

    var body: some View {
        WithViewStore(store.scope(state: { $0.view }, action: ResetPasswordAction.view)) { viewStore in
            ZStack {
                VStack() {
                Text(R.string.localizable.authorizationEnterEmail())
                    .foregroundColor(Color(R.color.blackLabel()))
                    .font(.system(size: 20))
                    .fontWeight(.thin)
                
                FloatingTextField(R.string.localizable.authorizationEmail(),
                                  text: viewStore.binding(
                                    get: { $0.email },
                                    send: ViewAction.emailChanged
                                  )
                ).autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                .padding(20)

                Button(R.string.localizable.authorizationRestorePassword()) {
                    viewStore.send(.restorationButtonTapped)
                }.buttonStyle(TelemedButtonStyle())
                .padding(20)
                .padding(.top, 20)
            }
                    .alert(store.scope(state: { $0.alert }), dismiss: .alertDismissed)
            }
        }
    }
}
