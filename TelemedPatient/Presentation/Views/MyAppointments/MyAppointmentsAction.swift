//
//  MyAppointmentsAction.swift
//  TelemedPatient
//
//  Created by Galieva on 07.02.2021.
//

import Foundation

enum MyAppointmentsAction: Equatable {
    case getDoctorWorkSlots
    case workSlotsResponse(_ response: Result<[WorkSlot], DoctorProfileAPI.Error>)
    case workSlotsUpdated
    case editAppointment(_ editAppointmentAction: EditAppointmentAction)
    case editTapped(_ appointment: WorkSlot)
    case editAppointmentDismissed
    case alertDismissed
    case cancelAppointment(_ id: Int)
}
