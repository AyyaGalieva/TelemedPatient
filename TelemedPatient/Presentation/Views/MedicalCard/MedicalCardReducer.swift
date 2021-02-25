//
//  MedicalCardReducer.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 16.12.2020.
//

import Foundation
import ComposableArchitecture

let medicalCardReducer = Reducer<MedicalCardState, MedicalCardAction, MedicalCardEnvironment>.combine(
    medrecordReducer.forEach(
      state: \.medrecordStates,
      action: /MedicalCardAction.idMedrecord,
      environment: { MedrecordEnvironment(
        medicalCardClient: $0.medicalCardClient,
        mainQueue: $0.mainQueue,
        progressHUD: $0.progressHUD
      )}
    ),
    medrecordReducer.optional().pullback(
            state: \.newMedrecordState,
            action: /MedicalCardAction.medrecord,
            environment: { MedrecordEnvironment(
                medicalCardClient: $0.medicalCardClient,
                mainQueue: $0.mainQueue,
                progressHUD: $0.progressHUD
              )}),
    Reducer<MedicalCardState, MedicalCardAction, MedicalCardEnvironment> { state, action, environment in
        switch action {
        case .fetchMedrecords:
            state.newMedrecordState = MedrecordState(with: Medrecord(ownerRole: Medrecord.OwnerRole.ROLE_PATIENT.rawValue, patientId: state.ownerId))
            return environment
                .medicalCardClient
                .fetchMedrecords(state.ownerId)
                .receive(on: environment.mainQueue)
                .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                .catchToEffect()
                .map(MedicalCardAction.fetchMedrecordsResponse)
        case .fetchMedrecordsResponse(.success(let response)):
            state.medrecordStates.removeAll()
            response.list.forEach { medrecord in
                state.medrecordStates.insert(MedrecordState(with: medrecord), at: 0)
            }
            return .none
        case .fetchMedrecordsResponse(.failure(_)):
            // TODO: process errors
            return .none
        case .idMedrecord(id: _, medrecordAction: .emptyResponse(.success(_))):
            fallthrough
        case .medrecord(.emptyResponse(.success(_))):
            return Effect(value: MedicalCardAction.fetchMedrecords)
        default:
            return .none
        }
    }
)
