//
//  TelemedPatientApp.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 12.11.2020.
//
//

import SwiftUI
import ComposableArchitecture
import IQKeyboardManagerSwift
import SocketIO
import Combine
import SwiftDate

let manager = SocketManager.live//(socketURL: URL(string: "https://doctor.telemedicine.azcltd.com/")!, config: [.log(true)])

@main
struct TelemedPatientApp: App {


    var body: some Scene {
        WindowGroup {
            let appEnvironment = AppEnvironment.live
//            let appAuthorizationState: AppAuthorizationState = {
//                if let token = appEnvironment.secureStorage.getValue(key: AppEnvironment.authorizationTokenKey) {
//                    return AppAuthorizationState.authorized(token)
//                } else {
//                    return AppAuthorizationState.nonAuthorized(AuthorizationState(mode: .login(LoginState()), doctorLink: URL(string: "telemed://primu.online/Krivobok")!))
//                }
//            }()
            let appState = AppState(appAuthorizationState: .unknown)
            let store = Store<AppState, AppAction>(initialState: appState,
                                                   reducer: appReducer,
                                                   environment: appEnvironment)
            WithViewStore(store) { viewStore in
                AppView(store: store).onAppear() {
                    SwiftDate.defaultRegion = Region.current
                    IQKeyboardManager.shared.enable = true
                    UINavigationBar.appearance().barTintColor = R.color.cornflowerBlue()
                    manager.defaultSocket.on(clientEvent: .connect) { data, ack in
                        print("socket connected")
                    }
                    manager.defaultSocket.on(clientEvent: .error) { data, ack in
                        print("socket error")
                    }
                    manager.defaultSocket.connect()
                }
            }
        }
    }
}
