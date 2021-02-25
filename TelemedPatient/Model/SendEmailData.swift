//
//  SendEmailData.swift
//  TelemedPatient
//
//  Created by Galieva on 10.12.2020.
//

public struct SendEmailData: Encodable, Decodable, Equatable {
    public var email: String
    public var role: String
}

