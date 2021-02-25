//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture
import Combine

struct AppEnvironment {

    static let authorizationTokenKey = "authorization_token"
    static let profileIDKey = "profile_id"

    var mainQueue: AnySchedulerOf<DispatchQueue>
    var authorizationClient: AuthorizationClient
    var profileClient: ProfileClient
    var doctorProfileClient: DoctorProfileClient
    var medicalCardClient: MedicalCardClient
    var workSlotsClient: WorkSlotsClient
    var resetPasswordClient: ResetPasswordClient
    var feedbackClient: FeedbackClient
    var secureStorage: ISecureStorageService
    var socketClient: SocketClient
    var progressHUD: IProgressHUD

    static let live = AppEnvironment(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            authorizationClient: .live,
            profileClient: .live,
            doctorProfileClient: .live,
            medicalCardClient: .live,
            workSlotsClient: .live,
            resetPasswordClient: .live,
            feedbackClient: .live,
            secureStorage: ValetStorageService(),
            socketClient: SocketClient.live,
            progressHUD: ProgressHUDPresenter())
}

extension AppEnvironment {

    var authorizationToken: String? {
        secureStorage.getValue(key: Self.authorizationTokenKey)
    }

    func setToken(_ token: String?) {
        secureStorage.save(value: token, key: Self.authorizationTokenKey)
    }

    var profileID: Int? {
        Int(secureStorage.getValue(key: Self.profileIDKey) ?? "")
    }

    func setProfileID(_ profileID: Int?) {
        guard let profileID = profileID else {
            secureStorage.remove(key: Self.profileIDKey)
            return
        }
        secureStorage.save(value: "\(profileID)", key: Self.profileIDKey)
    }
}