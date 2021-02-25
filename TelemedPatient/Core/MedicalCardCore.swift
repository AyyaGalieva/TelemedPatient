//
//  MedicalCardCore.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 15.12.2020.
//

import Foundation
import ComposableArchitecture
import Moya
import SwiftUI

// MARK: - ShortMedrecord

struct ShortMedrecord: Equatable, Identifiable {
    
    init(_ note: Medrecord) {
        guard let id = note.id else { fatalError() }
        medrecordDate = note.longFormatDate
        doctorSpecialty = note.doctorSpecialty
        doctorName = note.doctorName
        diagnosis = note.diagnosis
        self.id = id
    }
    
    public let id: Int
    public let medrecordDate: String
    public let doctorSpecialty: String
    public let doctorName: String
    public let diagnosis: String
}

// MARK: - Medrecord

public struct NoteFile: Equatable, Codable {
    
    public var id: String
    public var link: String
    public var name: String
}

struct Medrecord: Equatable, Identifiable {
    
    enum OwnerRole: String {
        case ROLE_PATIENT
        case ROLE_DOCTOR
    }
    
    internal init(id: Int? = nil,
                  medrecordDate: String = String.currentDate,
                  ownerRole: String,
                  patientId: String,
                  doctorId: String? = nil,
                  doctorName: String = "",
                  doctorSpecialty: String = "",
                  anamnesis: String = "",
                  description: String? = nil,
                  diagnosis: String = "",
                  treatment: String = "",
                  cost: Float = 0,
                  isDeleted: Bool? = nil,
                  files: [NoteFile] = []) {
        self.id = id
        self.medrecordDate = medrecordDate
        self.ownerRole = ownerRole
        self.patientId = patientId
        self.doctorId = doctorId
        self.doctorName = doctorName
        self.doctorSpecialty = doctorSpecialty
        self.anamnesis = anamnesis
        self.description = description
        self.diagnosis = diagnosis
        self.treatment = treatment
        self.cost = cost
        self.isDeleted = isDeleted
        self.files = files
    }
    
    public var id: Int?
    public var medrecordDate: String
    public var ownerRole: String
    public var patientId: String
    public var doctorId: String?
    public var doctorName: String
    public var doctorSpecialty: String
    public var anamnesis: String
    public var description: String?
    public var diagnosis: String
    public var treatment: String
    public var cost: Float? // сейчас в ответе может придти null, но вообще это странно
    public var isDeleted: Bool?
    public var files: [NoteFile]
    
    public var isValid: Bool {
        !medrecordDate.isEmpty && doctorName.isFullName && !doctorSpecialty.isEmpty && !patientId.isEmpty && !ownerRole.isEmpty
    }
    
    public var longFormatDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = String.shortDateFormat
        guard let date = formatter.date(from: medrecordDate) else {
            return medrecordDate
        }
        // пока у нас только русский, захардкодил локализацию для даты
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = String.longDateFormat
        return formatter.string(from: date)
    }
    
    public mutating func setMedrecordDate(withLongDate longDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = String.longDateFormat
        guard let date = formatter.date(from: longDate) else { return }
        formatter.dateFormat = String.shortDateFormat
        medrecordDate = formatter.string(from: date)
    }
}

extension Medrecord: Codable {}

extension Medrecord {
    
    static let mock = Medrecord(id: 0, medrecordDate: "2020-09-25", ownerRole: "", patientId: "", doctorId: "", doctorName: "Сигизмунд Шломо Фрейд", doctorSpecialty: "Психолог", anamnesis: "", description: nil, diagnosis: "Идиот", treatment: "", cost: 200, isDeleted: false, files: [])
}

// MARK: - FetchNotesResponse

struct FetchMedrecordsResponse: Decodable {
    
    public let totalCount: Int
    public let count: Int
    public let list: [Medrecord]
}

//// MARK: - LoadFileResponse
//
//struct LoadFileResponse: Decodable {
//
//    public let id: String
//    public let link: String
//    public let name: String
//}

// MARK: - MedicalCardClient

public struct MedicalCardClient {
    
    var fetchMedrecords: (_ ownerId: String) -> Effect<FetchMedrecordsResponse, MedrecordAPI.Error>
    var loadImageFile: (_ image: NamedUIImage) -> Effect<NoteFile, FileAPI.Error>
    var createMedrecord: (_ medrecord: Medrecord) -> Effect<Empty, MedrecordAPI.Error>
    var updateMedrecord: (_ medrecord: Medrecord) -> Effect<Empty, MedrecordAPI.Error>
    var deleteMedrecord: (_ id: Int) -> Effect<Empty, MedrecordAPI.Error>

    private static let medicalCardAPI = APIProvider<MedrecordAPI>()
    private static let fileAPI = APIProvider<FileAPI>()
}

extension MedicalCardClient {
    public static let live = MedicalCardClient(
        fetchMedrecords: { id in
            Effect.future { callback in
                medicalCardAPI.request(.fetchMedrecords(ownerId: id)) { result in
                    callback(result)
                }
            }.eraseToEffect()
        },
        loadImageFile: { image in
            Effect.future { callback in
                fileAPI.request(.loadImage(image)) { result in
                    callback(result)
                }
            }
        },
        createMedrecord: { medrecord in
            Effect.future { callback in
                medicalCardAPI.request(.createMedrecord(medrecord)) { result in
                    callback(result)
                }
            }
        },
        updateMedrecord: { medrecord in
            Effect.future { callback in
                medicalCardAPI.request(.updateMedrecord(medrecord)) { result in
                    callback(result)
                }
            }
        },
        deleteMedrecord: { id in
            Effect.future { callback in
                medicalCardAPI.request(.deleteMedrecord(id)) { result in
                    callback(result)
                }
            }
        }
    )
}
