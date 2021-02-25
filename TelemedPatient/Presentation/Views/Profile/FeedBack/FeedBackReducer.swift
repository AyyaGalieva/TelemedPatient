//
//  FeedBackReducer.swift
//  TelemedPatient
//
//  Created by Galieva on 12.01.2021.
//

import Foundation
import ComposableArchitecture

var feedBackReducer = Reducer<FeedBackState, FeedBackAction, FeedBackEnvironment> { state, action, environment in
    switch action {
    case .commentChanged(let comment):
        state.comment = comment
        return .none
    case .sendButtonTapped:
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment.feedbackClient
                        .sendFeedback(FeedbackRequest(id: state.id, ownerId: state.ownerId, comment: state.comment))
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(FeedBackAction.sendFeedbackResponse)
        )
    case .sendFeedbackResponse(let result):
        switch result {
        case .success:
            state.alert = .init(title: .init(R.string.localizable.feedbackSendMessage()))
        case .failure(let error):
            state.alert = .init(title: .init(error.localizedDescription))
        }
        return environment.progressHUD.dismiss().fireAndForget()
    case .validate:
        state.isFormValid = !state.comment.isEmpty
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    }
}
