//
//  ProfileEnvironment.swift
//  TelemedPatient
//
//  Created by Galieva on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct ProfileEnvironment {
    public var profileClient: ProfileClient
    public var feedbackClient: FeedbackClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
