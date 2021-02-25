//
//  EditAppointmentAction.swift
//  TelemedPatient
//
//  Created by Galieva on 10.02.2021.
//

import ComposableArchitecture

enum EditAppointmentAction: Equatable {
    case textChanged(_ text: String)
    case updateAppointment
    case deleteAppointment(appointment: WorkSlot?)
    case updateAppointmentResponse(_ response: Result<Empty, WorkSlotsAPI.Error>)
    case deleteAppointmentResponse(_ response: Result<Empty, WorkSlotsAPI.Error>)
    case cancel
}
