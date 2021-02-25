//
//  ResetPasswordEnvironment.swift
//  TelemedPatient
//
//  Created by Galieva on 21.12.2020.
//

import Foundation
import ComposableArchitecture

struct ResetPasswordEnvironment {
    public var resetPasswordClient: ResetPasswordClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
