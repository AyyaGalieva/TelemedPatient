//
// Created by Андрей Кривобок on 21.12.2020.
//

import Foundation
import ComposableArchitecture
import SwiftDate

public struct GetWorkSlotsRequest {
    var owner: String
    var begin: Date?
}

public struct WorkSlot: Decodable, Equatable, Hashable {

    public enum Status: String, Equatable, Codable {
        case active = "ACTIVE"
        case booked = "BOOKED"
        case confirmed = "CONFIRMED"
        case schedule = "SCHEDULE"
    }

    var id: Int
    var label: String
    var beginDateTime: Date
    var endDateTime: Date
    var status: Status
    var description: String?
    var color: String
    var service: Service?
    var ownerId: String?
    var customerId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case label
        case beginDateTime
        case endDateTime
        case status
        case description
        case color
        case ownerId
        case customerId
        case service = "doctorSvc"
    }
}

extension WorkSlot {

    public var beginDateTimeString: String {
        let dateFormatter = DateFormatter.sharedFormatter(forRegion: .current, format: "yyyy.MM.dd HH:mm")
        return dateFormatter.string(from: beginDateTime)
    }

    public var dateString: String {
        let dateFormatter = DateFormatter.sharedFormatter(forRegion: .current, format: "yyyy.MM.dd")
        return dateFormatter.string(from: beginDateTime)
    }

    public var date: Date {
        beginDateTime.dateAtStartOf(.day)
    }
    
    public var appointmentDateTimeString: String {
        let dateFormatter = DateFormatter.sharedFormatter(forRegion: .current, format: "EEEE, dd\(R.string.localizable.myAppointmentsDateSuffix()) MMMM - HH:mm")
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: beginDateTime).capitalizingFirstLetter()
    }
}

public struct CreateAppointmentRequest: Equatable, Encodable {
    var label: String
    var description: String
    var begin: String
    var end: String
    let color = "#f57c00" // TODO: check this
    let colorDefault = "#f57c00" // TODO: check this
    var ownerId: String
    let status = WorkSlot.Status.booked
    var doctorSvc: Service
    var doctorSvcId: Int
    var customerId: String

    init(patientProfile: PatientProfile, doctorProfile: DoctorProfile, timeSlot: TimeSlot, description: String) {
        label = patientProfile.name ?? ""
        self.description = description
        begin = timeSlot.start.toString(.custom("yyyy-MM-dd HH:mm"))
        end = timeSlot.end.toString(.custom("yyyy-MM-dd HH:mm"))
        ownerId = doctorProfile.ownerId
        doctorSvc = timeSlot.service
        doctorSvcId = timeSlot.service.id
        customerId = patientProfile.ownerId
    }
}

public struct UpdateAppointmentRequest: Equatable, Encodable {
    var id: Int
    var label: String
    var description: String
    var begin: String
    var bedinDateTime: Date
    var end: String
    var endDateTime: Date
    var color: String
    let colorDefault = "#f57c00" // TODO: check this
    var ownerId: String?
    var doctorSvc: Service?
    var doctorSvcId: Int?
    var customerId: String?
    var status: String
    
    init(appointment: WorkSlot, description: String) {
        id = appointment.id
        label = appointment.label
        self.description = description
        begin = appointment.beginDateTime.toString(.custom("yyyy-MM-dd HH:mm"))
        end = appointment.endDateTime.toString(.custom("yyyy-MM-dd HH:mm"))
        ownerId = appointment.ownerId
        doctorSvc = appointment.service
        doctorSvcId = appointment.service?.id
        customerId = appointment.customerId
        bedinDateTime = appointment.beginDateTime
        endDateTime = appointment.endDateTime
        status = appointment.status.rawValue
        color = appointment.color
    }
}

// TODO: rename to AppointmentsClient
public struct WorkSlotsClient {
    var getWorkSlots: (GetWorkSlotsRequest) -> Effect<[WorkSlot], WorkSlotsAPI.Error>
    var createAppointment: (CreateAppointmentRequest) -> Effect<WorkSlot, WorkSlotsAPI.Error>
    var updateAppointment: (UpdateAppointmentRequest, Int) -> Effect<Empty, WorkSlotsAPI.Error>
    var deleteAppointment: (_ id: Int) -> Effect<Empty, WorkSlotsAPI.Error>

    private static let workSlotsAPI = APIProvider<WorkSlotsAPI>()
}

extension WorkSlotsClient {

    public static let live = WorkSlotsClient(
            getWorkSlots: { request  in
                Effect.future { callback in
                    workSlotsAPI.request(.getSlots(owner: request.owner, begin: request.begin)) { result in
                        callback(result)
                    }
                }
            },
            createAppointment: { request in
                Effect.future { callback in
                    workSlotsAPI.request(.createAppointment(request)) { result in
                        callback(result)
                    }
                }
            },
        updateAppointment: { (request, workSlotID) in
            Effect.future { callback in
                workSlotsAPI.request(.updateAppointment(request, workSlotID: workSlotID)) { result in
                    callback(result)
                }
            }
        },
        deleteAppointment: { id in
            Effect.future { callback in
                workSlotsAPI.request(.deleteAppointment(id)) { result in
                    callback(result)
                }
            }
        }
    )
}
