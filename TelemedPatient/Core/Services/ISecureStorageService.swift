//
// Created by Андрей Кривобок on 03.12.2020.
//

import Foundation
import Valet

protocol ISecureStorageService {
    func save(value: String?, key: String)
    func save(data: Data?, key: String)
    func getValue(key: String) -> String?
    func getData(key: String) -> Data?
    func remove(key: String)
}

class ValetStorageService: ISecureStorageService {

    private struct Constants {
        static let valetIdentifier = "com.azoft.telemed.patient"
    }

    private var valet: Valet {
        return Valet.valet(with: Identifier(nonEmpty: Constants.valetIdentifier)!, accessibility: .whenUnlocked)
    }

    func save(value: String?, key: String) {
        if let value = value {
            try? valet.setString(value, forKey: key)
        } else {
            try? valet.removeObject(forKey: key)
        }
    }

    func save(data: Data?, key: String) {
        if let data = data {
            try? valet.setObject(data, forKey: key)
        } else {
            try? valet.removeObject(forKey: key)
        }
    }

    func getValue(key: String) -> String? {
        try? valet.string(forKey: key)
    }

    func getData(key: String) -> Data? {
        try? valet.object(forKey: key)
    }

    func remove(key: String) {
        try? valet.removeObject(forKey: key)
    }
}
