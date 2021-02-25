//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct SetNewPasswordEnvironment {
    public var resetPasswordClient: ResetPasswordClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
}
