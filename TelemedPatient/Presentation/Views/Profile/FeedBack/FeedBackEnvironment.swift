//
//  FeedBackEnvironment.swift
//  TelemedPatient
//
//  Created by Galieva on 12.01.2021.
//

import Foundation
import ComposableArchitecture

struct FeedBackEnvironment {
    public var feedbackClient: FeedbackClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var progressHUD: IProgressHUD
}
