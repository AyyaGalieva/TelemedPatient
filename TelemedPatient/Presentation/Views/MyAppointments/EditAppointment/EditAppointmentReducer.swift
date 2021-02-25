//
//  EditAppointmentReducer.swift
//  TelemedPatient
//
//  Created by Galieva on 10.02.2021.
//

import ComposableArchitecture

let editAppointmentReducer = Reducer<EditAppointmentState, EditAppointmentAction, EditAppointmentEnvironment> { state, action, environment in
    switch action {
    case .textChanged(let text):
        state.text = String(text.prefix(200))
        return  .none
    case .updateAppointment:
        let updateAppointmentRequest = UpdateAppointmentRequest(
            appointment: state.appointment, description: state.text)
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment.workSlotsClient
                        .updateAppointment(updateAppointmentRequest, state.appointment.id)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(EditAppointmentAction.updateAppointmentResponse)
        )
    case .deleteAppointment(_):
        return .concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment.workSlotsClient
                        .deleteAppointment(state.appointment.id)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(EditAppointmentAction.deleteAppointmentResponse)
        )
    case .updateAppointmentResponse(let result),
         .deleteAppointmentResponse(let result):
        switch result {
        case .success:
            // TODO process success
            break
        case .failure:
            // TODO process error
            break
        }
        return environment.progressHUD.dismiss().fireAndForget()
    case .cancel:
        return .none
    }
}

