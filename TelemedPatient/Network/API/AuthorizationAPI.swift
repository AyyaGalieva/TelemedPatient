//
//  AuthorizationAPI.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 18.11.2020.
//

import Moya
import Foundation

enum AuthorizationAPI: Equatable {
    case login(email: String, password: String)
    case signUp(email: String, password: String, fio: String, phone: String)
}

// TODO extract base
extension AuthorizationAPI: TargetType {

    public var path: String {
        switch self {
        case .login: return "auth/login"
        case .signUp: return "auth/signup/patient"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login: return Method.post
        case .signUp: return Method.post
        }
    }

    public var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case let .signUp(email, password, fio, phone):
            return .requestParameters(parameters: ["email": email, "password": password, "name": fio, "phone": phone], encoding: JSONEncoding.default)
        }
    }

    public var validationType: ValidationType {
        .successAndRedirectCodes
    }
}

extension AuthorizationAPI: FallibleService {

}