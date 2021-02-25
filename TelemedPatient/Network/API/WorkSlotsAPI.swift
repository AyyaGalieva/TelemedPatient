//
// Created by Андрей Кривобок on 17.12.2020.
//

import Foundation
import Moya

fileprivate let isoDateFormatter = ISO8601DateFormatter()

enum WorkSlotsAPI {
    case getSlots(owner: String, begin: Date?)
    case createAppointment(_ request: CreateAppointmentRequest)
    case updateAppointment(_ request: UpdateAppointmentRequest, workSlotID: Int)
    case deleteAppointment(_ id: Int)
}

extension WorkSlotsAPI: TargetType {

    var path: String {
        switch self {
        case .getSlots: return "work/slot"
        case .createAppointment: return "work/slot"
        case let .updateAppointment(_, workSlotID): return "work/slot/\(workSlotID)"
        case let .deleteAppointment(id): return "work/slot/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getSlots: return .get
        case .createAppointment: return .post
        case .updateAppointment: return .put
        case .deleteAppointment: return .delete
        }
    }

    var task: Task {
        switch self {
        case let .getSlots(owner: owner, begin: begin):
            var values = [
                Filter(key: "status", value: "DELETED", operator: .NE, valueType: .WorkSlotStatus),
                Filter(key: "ownerId", value: owner, operator: .EQ, valueType: .UUID)
            ]
            if let begin = begin {
                values.append(Filter(key: "begin", value: isoDateFormatter.string(from: begin), operator: .GE, valueType: .OffsetDateTime))
            }
            let filters = Filters(values: values)
            return .requestParameters(parameters: ["filters": filters], encoding: URLEncoding.default)
        case .createAppointment(let request):
            let parameters = ["data": request]
            return .requestCustomJSONEncodable(parameters, encoder: JSONEncoder())
        case let .updateAppointment(request, _):
            let parameters = ["data": request]
            return .requestCustomJSONEncodable(parameters, encoder: JSONEncoder())
        case .deleteAppointment:
            return .requestPlain
        }
    }
}

extension WorkSlotsAPI: Mappable {

    var mappingPath: String? {
        switch self {
        case .getSlots:
            return "listResult.list"
        case .createAppointment, .updateAppointment:
            return "data"
        default: return nil
        }
    }
}

extension WorkSlotsAPI: FallibleService {}

extension WorkSlotsAPI: AccessTokenAuthorizable {

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}
