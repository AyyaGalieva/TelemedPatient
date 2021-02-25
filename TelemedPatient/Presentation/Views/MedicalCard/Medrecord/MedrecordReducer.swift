//
//  MedrecordReducer.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 21.12.2020.
//

import Foundation
import ComposableArchitecture

let medrecordReducer = Reducer<MedrecordState, MedrecordAction, MedrecordEnvironment> { state, action, environment in
    switch action {
    case .medrecordDateChanged(let date):
        state.medrecord.setMedrecordDate(withLongDate: date)
        return .none
    case .doctorFullNameChanged(let doctorFullName):
        state.medrecord.doctorName = doctorFullName
        return .none
    case .doctorSpecialtyChanged(let speciality):
        state.medrecord.doctorSpecialty = speciality
        return .none
    case .anamnesisChanged(let anamnesis):
        state.medrecord.anamnesis = anamnesis
        return .none
    case .diagnosisChanged(let diagnosis):
        state.medrecord.diagnosis = diagnosis
        return .none
    case .treatmentChanged(let treatment):
        state.medrecord.treatment = treatment
        return .none
    case .imageFileAttached(let attachedImage):
        var image = attachedImage
        if image.name == nil {
            image.name = R.string.localizable.medicalCardAttachment(state.namelessFilesCount + 1)
            state.wasNamelessFile = true
        }
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment
                        .medicalCardClient
                        .loadImageFile(image)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(MedrecordAction.loadImageFileResponse)
        )
    case .costChanged(let cost):
        state.medrecord.cost = Float(cost)
        state.costString = cost
        return .none
    case .saveButtonTapped(let presentationMode):
        state.presentationMode = presentationMode
        let requestEffect = state.medrecord.id == nil ?
                environment
                        .medicalCardClient
                        .createMedrecord(state.medrecord)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(MedrecordAction.emptyResponse)
                :
                environment
                        .medicalCardClient
                        .updateMedrecord(state.medrecord)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(MedrecordAction.emptyResponse)
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                requestEffect
        )
    case .deleteButtonTapped(let presentationMode):
        state.presentationMode = presentationMode
        guard let id = state.medrecord.id else { return  .none }
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment
                        .medicalCardClient
                        .deleteMedrecord(id)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(MedrecordAction.emptyResponse)
        )
    case .loadImageFileResponse(let result):
        switch result {
        case .success(let file):
            state.medrecord.files.append(file)
            if state.wasNamelessFile {
                state.namelessFilesCount += 1
            }
            state.wasNamelessFile = false
        case .failure:
            state.wasNamelessFile = false
                // TODO: process errors
        }
        return environment.progressHUD.dismiss().fireAndForget()
    case .emptyResponse(let result):
        switch result {
        case .success:
            state.presentationMode?.wrappedValue.dismiss() // TODO replace this solution
        case .failure:
            state.presentationMode = nil
                // TODO: process errors
        }
        return environment.progressHUD.dismiss().fireAndForget()
    }
}
