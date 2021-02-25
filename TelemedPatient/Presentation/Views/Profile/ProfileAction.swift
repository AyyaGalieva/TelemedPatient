//
//  ProfileAction.swift
//  TelemedPatient
//
//  Created by Galieva on 16.12.2020.
//

import Foundation
import SwiftUI

enum ProfileAction: Equatable {
    case surnameChanged(_ surname: String)
    case nameChanged(_ name: String)
    case patronymicChanged(_ patronymic: String)
    case specialtyChanged(_ specialty: String)
    case cityChanged(_ city: String)
    case dateOfBirthChanged(_ dateOfBirth: String)
    case phoneChanged(_ phone: String)
    case photoChanged(_ photo: UIImage)
    case allergyChanged(_ allergy: String)
    case emptyResponse(_ response: Result<Empty, ProfileAPI.Error>)
    case logoutButtonTapped
    case feedBack(_ feedBackAction: FeedBackAction)
    case logout
}

extension ProfileAction {

    static func view(_ localAction: ProfileView.ViewAction) -> Self {
        switch localAction {
        case let .surnameChanged(surname):
            return .surnameChanged(surname)
        case let .nameChanged(name):
            return .nameChanged(name)
        case let .patronymicChanged(patronymic):
            return .patronymicChanged(patronymic)
        case let .specialtyChanged(specialty):
            return .specialtyChanged(specialty)
        case let .cityChanged(city):
            return .cityChanged(city)
        case let .dateOfBirthChanged(dateOfBirth):
            return .dateOfBirthChanged(dateOfBirth)
        case let .phoneChanged(phone):
            return .phoneChanged(phone)
        case let .allergyChanged(allergy):
            return .allergyChanged(allergy)
        case let .photoChanged(photo):
            return .photoChanged(photo)
        case .logoutButtonTapped:
            return .logoutButtonTapped
        }
    }
}
