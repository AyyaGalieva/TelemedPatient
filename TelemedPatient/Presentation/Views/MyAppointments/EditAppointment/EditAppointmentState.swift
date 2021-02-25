//
//  EditAppointmentState.swift
//  TelemedPatient
//
//  Created by Galieva on 10.02.2021.
//

import ComposableArchitecture

struct EditAppointmentState: Equatable {
    var appointment: WorkSlot
    var text: String = ""
}
