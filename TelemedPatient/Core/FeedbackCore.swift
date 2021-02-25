//
//  FeedbackCore.swift
//  TelemedPatient
//
//  Created by Galieva on 12.01.2021.
//

import Foundation
import ComposableArchitecture
import Moya

public struct FeedbackRequest {
    public var id: Int
    public var ownerId: String
    public var comment: String
}

public struct FeedbackClient {
    var sendFeedback: (FeedbackRequest) -> Effect<Empty, FeedbackAPI.Error>

    private static let feedbackAPI = APIProvider<FeedbackAPI>()
}

extension FeedbackClient {
    public static let live = FeedbackClient(
            sendFeedback: { request in
                Effect.future { callback in
                    feedbackAPI.request(.sendFeedback(request.id, ownerId: request.ownerId, text: request.comment)) { result in
                        callback(result)
                    }
                }.eraseToEffect() }
    )
}
