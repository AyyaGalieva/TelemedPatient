//
//  MedicalCardAction.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 16.12.2020.
//

import Foundation

enum MedicalCardAction {

    case fetchMedrecords
    case fetchMedrecordsResponse(_ response: Result<FetchMedrecordsResponse, MedrecordAPI.Error>)
    
    case idMedrecord(id: Int, medrecordAction: MedrecordAction)
    case medrecord(_ medrecordAction: MedrecordAction)
}
