//
//  FeedBackState.swift
//  TelemedPatient
//
//  Created by Galieva on 12.01.2021.
//

import Foundation
import ComposableArchitecture

struct FeedBackState: Equatable {
    var id = 0
    var ownerId = ""
    var comment = ""
    var isFormValid = false
    var alert: AlertState<FeedBackAction>?
}

extension FeedBackState {

    var view: FeedBackView.ViewState {
        FeedBackView.ViewState(id: id,
                               ownerId: ownerId,
                               comment: comment,
                               isSendFeedbackButtonDisabled: !isFormValid)
    }
}
