//
// Created by Андрей Кривобок on 15.01.2021.
//

import ComposableArchitecture

enum CreateAppointmentAction {
    case textChanged(_ text: String)
    case createAppointment
    case createAppointmentResponse(_ response: Result<WorkSlot, WorkSlotsAPI.Error>)
    case cancel
}
