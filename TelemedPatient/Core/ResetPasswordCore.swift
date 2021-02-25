//
//  ResetPasswordCore.swift
//  TelemedPatient
//
//  Created by Galieva on 08.12.2020.
//

import Foundation
import ComposableArchitecture
import Moya

public struct SendEmailRequest: Decodable, Encodable, Equatable {
    public var data: SendEmailData
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .data)
    }
    
    var dictionary: [String : Any] {
        get {
            let dictionary = self.dict ?? [:]
            
            return dictionary.compactMapValues { $0 }
        }
    }
}

public struct ResetPasswordResponse: Equatable {
}

extension ResetPasswordResponse: Decodable { }

public struct ResetPasswordClient {
    var sendEmail: (SendEmailRequest) -> Effect<ResetPasswordResponse, ResetPasswordAPI.Error>

    private static let resetPasswordAPI = APIProvider<ResetPasswordAPI>()
}

extension ResetPasswordClient {
    public static let live = ResetPasswordClient(
            sendEmail: { request in
                Effect.future { callback in
                    resetPasswordAPI.request(.sendEmail(data: request)) { result in
                        callback(result)
                    }
                }.eraseToEffect() }
    )
}
