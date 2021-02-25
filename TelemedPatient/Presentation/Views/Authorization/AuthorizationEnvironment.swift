//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct AuthorizationEnvironment {
    public var authorizationClient: AuthorizationClient
    public var doctorProfileClient: DoctorProfileClient
    public var profileClient: ProfileClient
    public var resetPasswordClient: ResetPasswordClient
    public var feedbackClient: FeedbackClient
    public var secureStorage: ISecureStorageService
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
