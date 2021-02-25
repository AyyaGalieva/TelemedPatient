//
//  ResetPasswordAPI.swift
//  TelemedPatient
//
//  Created by Galieva on 08.12.2020.
//

import Moya
import Foundation

enum ResetPasswordAPI: Equatable {
    case sendEmail(data: SendEmailRequest)
    case check
    case setPassword(password: String)
}

// TODO extract base
extension ResetPasswordAPI: TargetType {

    public var path: String {
        switch self {
        case .sendEmail: return "resetpassword/email"
        case .check: return "resetpassword/check"
        case .setPassword: return "resetpassword/password"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .sendEmail, .setPassword: return Method.post
        case .check: return Method.get
        }
    }

    public var task: Task {
        switch self {
        case let .sendEmail(data):
            return .requestParameters(parameters: data.dictionary, encoding: JSONEncoding.default)
        case .check:
            return .requestPlain
        case let .setPassword(password):
            return .requestParameters(parameters: ["newPassword": password], encoding: JSONEncoding.default)
        }
    }
}

extension ResetPasswordAPI: FallibleService {

}
