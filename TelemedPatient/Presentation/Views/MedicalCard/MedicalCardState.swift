//
//  MedicalCardState.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 16.12.2020.
//

import Foundation
import ComposableArchitecture

struct MedicalCardState: Equatable {
    
    var ownerId: String
    
    var newMedrecordState: MedrecordState?
    var medrecordStates: IdentifiedArrayOf<MedrecordState> = []
}
