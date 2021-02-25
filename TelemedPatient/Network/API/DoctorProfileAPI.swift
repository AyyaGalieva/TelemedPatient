//
// Created by Андрей Кривобок on 17.12.2020.
//

import Moya

enum DoctorProfileAPI {
    case getProfileById(_ id: Int)
    case getProfileByNickname(_ nickname: String)
    case addPatient(_ doctorID: Int, patientID: Int)
}

extension DoctorProfileAPI: TargetType {

    public var path: String {
        switch self {
        case .getProfileById(let id): return "/doctor/profile/\(id)"
        case .getProfileByNickname: return "/doctor/profile"
        case let .addPatient(doctorID, patientID):
            return "doctor/profile/\(doctorID)/patient/\(patientID)"
        }
    }

    public var method: Method {
        switch self {
        case .getProfileById, .getProfileByNickname: return .get
        case .addPatient: return .post
        }
    }

    public var task: Task {
        switch self {
        case .getProfileById:
            return .requestPlain
        case .getProfileByNickname(let nickname):
            return .requestParameters(parameters: ["filters": ["nickname", nickname, "EQ"]], encoding: URLEncoding(arrayEncoding: .noBrackets))
        case .addPatient:
            return .requestPlain
        }
    }
}

extension DoctorProfileAPI: Mappable {

    var mappingPath: String? {
        switch self {
        case .getProfileByNickname: return "listResult.list"
        default: return nil
        }
    }
}

extension DoctorProfileAPI: FallibleService {}

extension DoctorProfileAPI: AccessTokenAuthorizable {

    public var authorizationType: AuthorizationType? {
        switch self {
        case .addPatient:
            return .bearer
        default:
            return .none
        }
    }
}
