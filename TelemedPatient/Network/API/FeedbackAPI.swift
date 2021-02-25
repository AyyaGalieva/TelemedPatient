//
//  FeedbackAPI.swift
//  TelemedPatient
//
//  Created by Galieva on 12.01.2021.
//

import Foundation
import SwiftUI
import Moya

enum FeedbackAPI {
    case sendFeedback(_ id: Int, ownerId: String, text: String)
}


extension FeedbackAPI: TargetType {

    public var path: String {
        switch self {
        case .sendFeedback: return "feedback"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .sendFeedback: return .post
        }
    }

    public var task: Task {
        switch self {
        case let .sendFeedback(id, ownerId, text):
            return .requestParameters(parameters: ["data": ["id" : id, "ownerId": ownerId, "ownerRole": "ROLE_PATIENT", "text": text]], encoding: JSONEncoding.default)
        }
    }
}

extension FeedbackAPI: AccessTokenAuthorizable {

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

extension FeedbackAPI: FallibleService {
}

extension FeedbackAPI: Mappable {

    var mappingPath: String? {
        switch self {
        case .sendFeedback: return "data"
        }
    }
}
