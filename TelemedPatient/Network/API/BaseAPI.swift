//
// Created by Андрей Кривобок on 10.12.2020.
//

import Foundation
import Moya
import Alamofire

extension TargetType {

    public var baseURL: URL {
        URL(string: "https://api.primet.online/api/v1/")! // production
//        URL(string: "https://api.telemedicine.azcltd.com/api/v1/")! // staging
    }

    public var validationType: ValidationType {
        .successAndRedirectCodes
    }

    public var headers: [Swift.String: Swift.String]? {
        nil
    }

    public var sampleData: Foundation.Data {
        fatalError("sampleData has not been implemented")
    }
}

protocol Mappable {
    var mappingPath: String? { get }
}

extension Mappable {
    var mappingPath: String? {
        nil
    }
}

typealias Empty = Alamofire.Empty
extension Empty: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
