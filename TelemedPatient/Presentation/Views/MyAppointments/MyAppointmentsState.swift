//
//  MyAppointmentsState.swift
//  TelemedPatient
//
//  Created by Galieva on 07.02.2021.
//

import ComposableArchitecture

struct MyAppointmentsState: Equatable {
    var doctorID: String?
    var patientUuid: String
    var workSlots: [Int:WorkSlot]?
    var appointments: [WorkSlot]?
    var history: [WorkSlot]?
    var editAppointmentState: EditAppointmentState?
    var alert: AlertState<MyAppointmentsAction>?
    var canceledAppointments: [WorkSlot] = []
    
    var view: MyAppointmentsView.ViewState {
        MyAppointmentsView.ViewState(editAppointmentPresented: editAppointmentState != nil)
    }
}
