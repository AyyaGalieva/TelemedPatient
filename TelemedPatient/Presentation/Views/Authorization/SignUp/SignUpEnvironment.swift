//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture
import ProgressHUD

struct SignUpEnvironment {
    public var authorizationClient: AuthorizationClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
