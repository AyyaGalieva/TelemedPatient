//
//  ProfileReducer.swift
//  TelemedPatient
//
//  Created by Galieva on 16.12.2020.
//

import Foundation
import ComposableArchitecture

let profileReducer = Reducer<ProfileState, ProfileAction, ProfileEnvironment>.combine(
    feedBackReducer.optional().pullback(
            state: \.sendFeedbackState,
            action: /ProfileAction.feedBack,
            environment: {
                FeedBackEnvironment(feedbackClient: $0.feedbackClient, mainQueue: $0.mainQueue, progressHUD: $0.progressHUD)
            }),
    Reducer<ProfileState, ProfileAction, ProfileEnvironment> ({ state, action, environment in
            switch action {
            case .surnameChanged(let surname):
                state.surname = surname
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .nameChanged(let name):
                state.name = name
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .patronymicChanged(let patronymic):
                state.patronymic = patronymic
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .specialtyChanged(let specialty):
                state.specialty = specialty
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .cityChanged(let city):
                state.city = city
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .dateOfBirthChanged(let dateOfBirth):
                state.dateOfBirth = dateOfBirth
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .phoneChanged(let phone):
                state.phone = phone
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case .photoChanged(let photo):
                return environment.profileClient.uploadPhoto(UploadPhotoRequest(profileID: state.id ,image: photo))
                    .receive(on: environment.mainQueue)
                    .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                    .catchToEffect()
                    .map(ProfileAction.emptyResponse)
            case .allergyChanged(let allergy):
                state.allergy = allergy
                return updateProfile(state: state, environment: environment)
                        .map(ProfileAction.emptyResponse)
            case let .emptyResponse(.success(response)):
                return .none
            case let .emptyResponse(.failure(error)):
                return .none
            case .logoutButtonTapped:
                return Effect(value: ProfileAction.logout)
            default:
                return .none
            }
        })
)

let dateFormatter = DateFormatter()

private func updateProfile(state: ProfileState, environment: ProfileEnvironment) -> Effect<Result<Empty, ProfileAPI.Error>, Never> {
    let fullName = state.surname + " " + state.name + " " + state.patronymic
    
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let date = dateFormatter.date(from: state.dateOfBirth)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    var birthday: String? = nil
    if let date = date {
        birthday = dateFormatter.string(from: date)
    }
    
    return environment.profileClient
        .updateProfile(UpdateProfileRequest(allergy: state.allergy, birthday: birthday, city: state.city, email: state.email, id: state.id, lastDoctorNickname: state.lastDoctorNickname, name: fullName, ownerId: state.uuid, phone: state.phone, specialty: state.specialty))
        .receive(on: environment.mainQueue)
        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
        .catchToEffect()
}

