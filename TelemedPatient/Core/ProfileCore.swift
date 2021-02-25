//
//  ProfileCore.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 09.12.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Moya

public struct UpdateProfileRequest { // TODO use Decodable Profile instead
    public var allergy: String?
    public var birthday: String?
    public var city: String?
    public var email: String
    public var id: Int
    public var lastDoctorNickname: String?
    public var name: String?
    public var ownerId: String?
    public var phone: String?
    public var photo: Photo?
    public var specialty: String?
}

public struct UploadPhotoRequest {
    public var profileID: Int
    public var image: UIImage
}

// TODO: extract to common area
public struct Photo: Equatable, Decodable {
    var id: String
    var link: String
    var name: String
}

extension Photo {

    var url: URL? {
        URL(string: link)
    }
}

public struct PatientProfile: Equatable, Decodable {
    var allergy: String?
    var birthday: String? // TODO: change to Date
    var city: String?
    var email: String
    var id: Int
    var lastDoctorNickname: String?
    var name: String?
    var ownerId: String
    var phone: String?
    var photo: Photo?
    var specialty: String?
}

public struct ProfileClient {
    var getProfile: (_ id: Int) -> Effect<PatientProfile, ProfileAPI.Error>
    var updateProfile: (UpdateProfileRequest) -> Effect<Empty, ProfileAPI.Error>
    var uploadPhoto: (UploadPhotoRequest) -> Effect<Empty, ProfileAPI.Error>

    private static let profileAPI = APIProvider<ProfileAPI>()
}

extension ProfileClient {
    public static let live = ProfileClient(
            getProfile: { id in
                Effect.future { callback in
                    profileAPI.request(.getProfile(id)) { result in
                        callback(result)
                    }
                }
            },
            updateProfile: { request in
                Effect.future { callback in
                    profileAPI.request(.updateProfile(
                            request.allergy,
                            birthday: request.birthday,
                            city: request.city,
                            email: request.email,
                            id: request.id,
                            lastDoctorNickname: request.lastDoctorNickname,
                            name: request.name,
                            ownerId: request.ownerId,
                            phone: request.phone,
                            photo: request.photo,
                            specialty: request.specialty,
                            patientID: request.id)) { result in
                        callback(result)
                    }
                }.eraseToEffect()
            }, uploadPhoto: { request in
                Effect.future { callback in
                    profileAPI.request(.uploadPhoto(image: request.image, patientID: request.profileID)) { result in
                        callback(result)
                    }
                }.eraseToEffect()
            }
    )
}
