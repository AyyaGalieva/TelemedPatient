//
// Created by Андрей Кривобок on 15.01.2021.
//

import ComposableArchitecture

let createAppointmentReducer = Reducer<CreateAppointmentState, CreateAppointmentAction, CreateAppointmentEnvironment> { state, action, environment in
    switch action {
    case .textChanged(let text):
        state.text = text
        return  .none
    case .createAppointment:
        let createAppointmentRequest = CreateAppointmentRequest(
                patientProfile: state.patientProfile,
                doctorProfile: state.doctorProfile,
                timeSlot: state.timeSlot,
                description: state.text)
        return Effect.concatenate(
                environment.progressHUD.show().fireAndForget(),
                environment.workSlotsClient
                        .createAppointment(createAppointmentRequest)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(CreateAppointmentAction.createAppointmentResponse)
        )
    case .createAppointmentResponse(let result):
        switch result {
        case .success:
            state.appointmentCreated = true
        case .failure:
            // TODO process error
            break
        }
        return environment.progressHUD.dismiss().fireAndForget()
    case .cancel:
        return .none
    }
}
