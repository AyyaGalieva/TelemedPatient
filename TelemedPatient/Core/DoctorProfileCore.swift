//
// Created by Андрей Кривобок on 17.12.2020.
//

import Foundation
import ComposableArchitecture
import Moya

struct Service: Codable, Equatable, Hashable {
    var id: Int
    var name: String = ""
    var price: Int = 0
    var enabled = false
    var iconName: String?
    var duration: Int = 30 // 30 min by default

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case enabled
        case iconName = "icon"
        case duration
    }

    static func ==(lhs: Service, rhs: Service) -> Bool {
        lhs.id == rhs.id
    }
}

struct DoctorProfile: Decodable, Equatable {
    var id: Int
    var ownerId: String
    var name: String?
    var specialty: String?
    var city: String?
    var phone: String?
    var seniority: String?
    var email: String?
    var aboutMe: String?
    var qualification: String?
    var birthday: String?
    var photo: Photo?
    var services: [Service] = []

    enum CodingKeys: String, CodingKey {
        case id
        case  ownerId
        case  name
        case  specialty
        case  city
        case  phone
        case  seniority
        case  email
        case  aboutMe
        case  qualification
        case  birthday
        case  photo
        case services = "doctorSvcList"
    }
}

public struct AddPatientRequest {
    public var doctorID: Int
    public var patientID: Int
}

public struct DoctorProfileClient {
    var getDoctorProfileById: (_ id: Int) -> Effect<DoctorProfile, DoctorProfileAPI.Error>
    var getDoctorProfileByNickname: (_ nickname: String) -> Effect<DoctorProfile, DoctorProfileAPI.Error>
    var addPatient: (AddPatientRequest) -> Effect<Empty, ProfileAPI.Error>

    private static let doctorProfileProvider = APIProvider<DoctorProfileAPI>()
}

extension DoctorProfileClient {

    public static let live = DoctorProfileClient(getDoctorProfileById: { doctorId in
        Effect.future { callback in
            doctorProfileProvider.request(.getProfileById(doctorId)) { result in
                callback(result)
            }
        }.eraseToEffect()
    }, getDoctorProfileByNickname: { doctorNickname in
        Effect.future { callback in
            doctorProfileProvider.request(.getProfileByNickname(doctorNickname)) { (result: Result<[DoctorProfile], DoctorProfileAPI.Error>) in
                switch result {
                case .success(let response):
                    if let profile = response.first {
                        callback(.success(profile))
                    } else {
                        callback(.failure(DoctorProfileAPI.Error.invalidResponseDataFormat))
                    }
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        }.eraseToEffect()
    },
        addPatient: { request in
            Effect.future { callback in
                doctorProfileProvider.request(.addPatient(request.doctorID, patientID: request.patientID)) { result in
                    callback(result)
                }
            }.eraseToEffect()
        })
}
