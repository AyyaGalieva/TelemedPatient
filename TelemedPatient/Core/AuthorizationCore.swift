//
// Created by Андрей Кривобок on 18.11.2020.
//

import Foundation
import ComposableArchitecture
import Moya

public struct LoginRequest {
    public var email: String
    public var password: String
}

public struct LoginValidation {
    
    public var isEmailValid: Bool
}

public struct SignUpRequest {
    public var email: String
    public var password: String
    public var fio: String
    public var phone: String
}

public struct AuthorizationResponse: Equatable {
    public var userId: String
    public var token: String
    public var email: String
    public var patientProfile: PatientProfile
}

extension AuthorizationResponse: Decodable { }

public struct AuthorizationClient {
    var login: (LoginRequest) -> Effect<AuthorizationResponse, AuthorizationAPI.Error>
    var signUp: (SignUpRequest) -> Effect<AuthorizationResponse, AuthorizationAPI.Error>
//    var validateLogin: (LoginRequest) -> Effect<LoginValidation>
    
    private static let authorizationAPI = APIProvider<AuthorizationAPI>()
}

extension AuthorizationClient {
    public static let live = AuthorizationClient(
            login: { request in
                Effect.future { callback in
                    authorizationAPI.request(.login(email: request.email, password: request.password)) { result in
                        callback(result)
                    }
                }.eraseToEffect() },
            signUp: { request in
                Effect.future { callback in
                    authorizationAPI.request(.signUp(email: request.email, password: request.password, fio: request.fio, phone: request.phone)) { result in
                        callback(result)
                    }
                }.eraseToEffect() }
    )
}
