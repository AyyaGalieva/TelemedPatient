//
// Created by Андрей Кривобок on 23.11.2020.
//

import Foundation
import Moya

protocol FallibleService: Equatable {
    associatedtype Error: NetworkError
}

extension FallibleService {
    typealias Error = DefaultAPIError
}

protocol NetworkError: Swift.Error, Equatable {
    static func error(from moyaError: MoyaError) -> Self
}

enum DefaultAPIError: NetworkError {

    case http(code: Int)
    case notConnectedToInternet
    case cannotConnectToServer
    case invalidResponseDataFormat
    case underlying(error: Swift.Error)
    case unknown

    static func error(from moyaError: MoyaError) -> DefaultAPIError {
        switch moyaError {
        case .statusCode(let response):
            return http(code: response.statusCode)
        case .underlying(let error, _):
            if let urlError = error as? URLError {
                switch urlError.errorCode {
                case URLError.notConnectedToInternet.rawValue: return .notConnectedToInternet
                case URLError.networkConnectionLost.rawValue: return .notConnectedToInternet
                case URLError.cannotFindHost.rawValue: return .notConnectedToInternet
                case URLError.cannotConnectToHost.rawValue: return .cannotConnectToServer
                default: return .underlying(error: error)
                }
            } else {
                return .underlying(error: error)
            }
        default: return .unknown
        }
    }

    static func ==(lhs: DefaultAPIError, rhs: DefaultAPIError) -> Bool {
        switch (lhs, rhs) {
        case let (.http(lhsCode), .http(rhsCode)):
            return lhsCode == rhsCode
        case (.notConnectedToInternet, .notConnectedToInternet),
             (.cannotConnectToServer, .cannotConnectToServer),
             (.invalidResponseDataFormat, .invalidResponseDataFormat),
             (.unknown, .unknown):
                return true
        case let (.underlying(lhsError), .underlying(rhsError)):
            let lhsNSError = lhsError as NSError
            let rhsNSError = rhsError as NSError
            return lhsNSError.domain == rhsNSError.domain && lhsNSError.code == rhsNSError.code
        default:
            return false
        }
    }
}

extension DefaultAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notConnectedToInternet: return R.string.localizable.errorsDefault()
        case .cannotConnectToServer: return R.string.localizable.errorsDefault()
        case .http: return R.string.localizable.errorsDefault()
        case .underlying: return R.string.localizable.errorsDefault()
        case .unknown: return R.string.localizable.errorsDefault()
        default: return R.string.localizable.errorsDefault()
        }
    }
}

class ErrorsProcessor: PluginType {

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {

        switch result {
        case .success(let response):
            switch response.statusCode {
            case 200, 204: return result
            default: return Result.failure(MoyaError.statusCode(response))
            }

        case .failure:
            return result
        }
    }

}
