//
// Created by Андрей Кривобок on 27.01.2021.
//

import Foundation
import SocketIO
import Combine
import ComposableArchitecture

struct SocketRoom: SocketData {
    var ownerId: String
    var roomId: String
    
    func socketRepresentation() throws -> SocketData {
        ["ownerId": ownerId, "roomId": roomId]
    }
}

typealias OnEvent = () -> Void

struct SocketClient {
    var connect: (_ room: SocketRoom) -> Effect<Never, Never>
    var onWorkSlotUpdated: () -> Effect<WorkSlot, Never>
}

extension SocketClient {
    public static let live = SocketClient(
        connect: { room in
            let socket = SocketManager.live.defaultSocket
            return .fireAndForget {
                let joinToGroup = {
                    socket.emit("find", room)
                }
                if socket.status == .connected {
                    joinToGroup()
                } else {
                    socket.once(clientEvent: .connect) { _, _ in
                        joinToGroup()
                    }
                }
            }
        }, onWorkSlotUpdated: {
            let socket = SocketManager.live.defaultSocket
            return .future { callback in
                socket.on("slotChanged") { workSlot in
                    callback(.success(workSlot))
                }
            }
        })
}

extension Decodable {
    init(from any: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: any)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
}

extension SocketIOClient {

    func on<T: Decodable>(_ event: String, callback: @escaping (T)-> Void) {
        self.on(event) { (data, _) in
            guard !data.isEmpty else {
                print("[SocketIO] \(event) data empty")
                return
            }

            do {
                let decoded = try T(from: data[0])
                callback(decoded)
            } catch {
                print("[SocketIO] \(event) data \(data) cannot be decoded to \(T.self): \(error)")
            }
        }
    }
}

extension SocketManager {
    static let live = SocketManager(socketURL: URL(string: "https://doctor.telemedicine.azcltd.com/")!, config: [.log(true)])
    static let debug = SocketManager(socketURL: URL(string: "https://doctor.telemedicine.azcltd.com/")!, config: [.log(true)])
}
