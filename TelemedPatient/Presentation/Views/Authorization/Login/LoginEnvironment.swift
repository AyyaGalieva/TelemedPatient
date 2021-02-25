//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct LoginEnvironment {
    public var authorizationClient: AuthorizationClient
    public var resetPasswordClient: ResetPasswordClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
