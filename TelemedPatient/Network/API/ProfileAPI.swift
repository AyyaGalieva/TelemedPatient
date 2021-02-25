//
//  ProfileAPI.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 09.12.2020.
//

import Foundation
import SwiftUI
import Moya

enum ProfileAPI {
    case getProfile(_ id: Int)
    case updateProfile(_ allergy: String?, birthday: String?, city: String?, email: String, id: Int, lastDoctorNickname: String?, name: String?, ownerId: String?, phone: String?, photo: Photo?, specialty: String?, patientID: Int)
    case uploadPhoto(image: UIImage, patientID: Int)
}


extension ProfileAPI: TargetType {

    public var path: String {
        switch self {
        case .getProfile(let id):
            return "patient/profile/\(id)"
        case let .updateProfile(_, _, _, _, _, _, _, _, _, _, _, patientID):
            return "patient/profile/\(patientID)"
        case let .uploadPhoto(_, patientID):
            return "patient/profile/\(patientID)/photo"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getProfile: return .get
        case .updateProfile: return .put
        case .uploadPhoto: return .post
        }
    }

    public var task: Task {
        switch self {
        case .getProfile:
            return .requestPlain
        case let .updateProfile(allergy, birthday, city, email, id, lastDoctorNickname, name, ownerId, phone, photo, specialty, _):
            return .requestParameters(parameters: ["data": ["allergy" : allergy, "birthday": birthday, "city": city, "email": email, "id": id, "lastDoctorNickname": lastDoctorNickname, "name": name, "ownerId": ownerId, "phone": phone, "photo": ["id": photo?.id, "link": photo?.link, "name": photo?.name], "specialty": specialty]], encoding: JSONEncoding.default)
        case .uploadPhoto(_, _):
            return .uploadMultipart(multipartBody!)
        }
    }
    
    var multipartBody: [Moya.MultipartFormData]? {
        switch self {
        case let .uploadPhoto(image, _):
            let imageData = image.jpegData(compressionQuality: 1.0)
            let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
            let fileName = String((0..<32).map{ _ in letters.randomElement()! }) + ".jpeg"
            let imageDataProvider = Moya.MultipartFormData(provider: MultipartFormData.FormDataProvider.data(imageData!), name: "photoFile", fileName: fileName, mimeType: "image/jpeg")
            return [imageDataProvider]
        default:
            return []
        }
    }
}

extension ProfileAPI: AccessTokenAuthorizable {

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

extension ProfileAPI: FallibleService {
    
}

extension ProfileAPI: Mappable {

    var mappingPath: String? {
        switch self {
        case .updateProfile, .getProfile: return "data"
        case .uploadPhoto: return ""
        }
    }
}
