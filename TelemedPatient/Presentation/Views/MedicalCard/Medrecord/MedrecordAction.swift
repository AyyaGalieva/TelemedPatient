//
//  MedrecordAction.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 21.12.2020.
//

import Foundation
import UIKit
import SwiftUI

enum MedrecordAction {
    case medrecordDateChanged(_ medrecordDate: String)
    case doctorFullNameChanged(_ doctorFullName: String)
    case doctorSpecialtyChanged(_ doctorSpecialty: String)
    case anamnesisChanged(_ anamnesis: String)
    case diagnosisChanged(_ diagnosis: String)
    case treatmentChanged(_ treatment: String)
    case imageFileAttached(_ image: NamedUIImage)
    case costChanged(_ cost: String)
    case loadImageFileResponse(_ response: Result<NoteFile, FileAPI.Error>)
    case saveButtonTapped(_ presentationMode: Binding<PresentationMode>)
    case emptyResponse(_ response: Result<Empty, FileAPI.Error>)
    case deleteButtonTapped(_ presentationMode: Binding<PresentationMode>)
}

extension MedrecordAction {

    static func view(_ localAction: MedrecordView.ViewAction) -> Self {
        switch localAction {
        case let .medrecordDateChanged(date):
            return .medrecordDateChanged(date)
        case let .doctorFullNameChanged(doctorFullName):
            return .doctorFullNameChanged(doctorFullName)
        case let .doctorSpecialtyChanged(speciality):
            return .doctorSpecialtyChanged(speciality)
        case let .anamnesisChanged(anamnesis):
            return .anamnesisChanged(anamnesis)
        case let .diagnosisChanged(diagnosis):
            return .diagnosisChanged(diagnosis)
        case let .treatmentChanged(treatment):
            return .treatmentChanged(treatment)
        case let .imageFileAttached(image):
            return .imageFileAttached(image)
        case let .costChanged(cost):
            return .costChanged(cost)
        case let .saveButtonTapped(presentationMode):
            return .saveButtonTapped(presentationMode)
        case let .deleteButtonTapped(presentationMode):
            return .deleteButtonTapped(presentationMode)
        }
    }
}
