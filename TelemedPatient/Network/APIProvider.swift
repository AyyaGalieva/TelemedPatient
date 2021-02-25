//
// Created by Андрей Кривобок on 23.11.2020.
//

import Foundation
import Moya

final class APIProvider<API: TargetType> where API: FallibleService {

    private var provider: MoyaProvider<API> = {
        let authorizationPlugin = AccessTokenPlugin { type in
            guard type == AuthorizationType.bearer else {
                return ""
            }

            // TODO: refactor this, temporary solution
            return ValetStorageService().getValue(key: AppEnvironment.authorizationTokenKey) ?? "" // TODO: get token from state??
        }

        return MoyaProvider<API>(plugins: [authorizationPlugin])
    }()

    @discardableResult
    func request<T: Decodable>(_ api: API, completion: @escaping (_ result: Result<T, API.Error>) -> Void) -> Cancellable {
        provider.request(api) { result in
            switch result {
            case .success(let response):
                if let emptyResponseType = T.self as? Empty.Type, let emptyValue = emptyResponseType.emptyValue() as? T {
                    completion(.success(emptyValue))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let value = try response.map(T.self, atKeyPath: (api as? Mappable)?.mappingPath, using: decoder)
                    completion(.success(value))
                } catch let error {
                    print(error)
                    completion(.failure(API.Error.error(from: .jsonMapping(response))))
                }
            case .failure(let moyaError):
                completion(.failure(API.Error.error(from: moyaError)))
            }
        }
    }
}
