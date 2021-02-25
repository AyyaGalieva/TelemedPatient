//
//  MedrecordAPI.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 18.12.2020.
//

import Moya
import Foundation

enum MedrecordAPI: Equatable {
    
    case fetchMedrecords(ownerId: String)
    case createMedrecord(_ medrecord: Medrecord)
    case updateMedrecord(_ medrecord: Medrecord)
    case deleteMedrecord(_ id: Int)
}

extension MedrecordAPI: TargetType {
    
    public var path: String {
        switch self {
        case .fetchMedrecords: return "patient/medrecord"
        case .createMedrecord: return "patient/medrecord"
        case .updateMedrecord(let medrecord): return "patient/medrecord/\(medrecord.id ?? -1)"
        case .deleteMedrecord(let id): return "patient/medrecord/\(id)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchMedrecords: return .get
        case .createMedrecord: return .post
        case .updateMedrecord: return .put
        case .deleteMedrecord: return .delete
        }
    }

    public var task: Task {
        switch self {
        case let .fetchMedrecords(ownerId):
            let filters = Filters(values: [
                Filter(key: "patientId", value: ownerId, operator: .EQ, valueType: .UUID),
                Filter(key: "isDeleted", value: true, operator: .NE, valueType: .Boolean)
            ])
            return .requestParameters(parameters: ["filters": filters], encoding: URLEncoding.default)
        case let .createMedrecord(medrecord):
            return .requestParameters(parameters: ["data": medrecord.dict], encoding: JSONEncoding.default)
        case let .updateMedrecord(medrecord):
            return .requestParameters(parameters: ["data": medrecord.dict], encoding: JSONEncoding.default)
        case .deleteMedrecord:
            return .requestPlain
        }
    }
}

extension MedrecordAPI: AccessTokenAuthorizable {

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

extension MedrecordAPI: Mappable {

    var mappingPath: String? {
        switch self {
            case .fetchMedrecords: return "listResult"
        default: return nil
        }
    }
}

extension MedrecordAPI: FallibleService {
    
}
