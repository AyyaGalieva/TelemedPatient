//
//  FeedBackAction.swift
//  TelemedPatient
//
//  Created by Galieva on 12.01.2021.
//

import Foundation

enum FeedBackAction: Equatable {
    case commentChanged(_ comment: String)
    case sendButtonTapped
    case validate
    case alertDismissed
    case sendFeedbackResponse(_ response: Result<Empty, ResetPasswordAPI.Error>)
}

extension FeedBackAction {

    static func view(_ localAction: FeedBackView.ViewAction) -> Self {
        switch localAction {
        case let .commentChanged(comment):
            return .commentChanged(comment)
        case .sendButtonTapped:
            return .sendButtonTapped
        case .validate:
            return .validate
        }
    }
}
