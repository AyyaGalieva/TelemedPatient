//
//  MyAppointmentsReducer.swift
//  TelemedPatient
//
//  Created by Galieva on 07.02.2021.
//

import ComposableArchitecture

let myAppointmentsReducer = Reducer<MyAppointmentsState, MyAppointmentsAction, MyAppointmentsEnvironment>.combine(
    editAppointmentReducer.optional().pullback(
            state: \.editAppointmentState,
            action: /MyAppointmentsAction.editAppointment,
            environment: {
                EditAppointmentEnvironment(
                        workSlotsClient: $0.workSlotsClient,
                        mainQueue: $0.mainQueue,
                        progressHUD: $0.progressHUD
                )
            }
        ),
    Reducer<MyAppointmentsState, MyAppointmentsAction, MyAppointmentsEnvironment> { state, action, environment in
    switch action {
    case .getDoctorWorkSlots:
        return environment
                .workSlotsClient
                .getWorkSlots(GetWorkSlotsRequest(owner: state.doctorID ?? ""))
                .receive(on: environment.mainQueue)
                .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                .catchToEffect()
                .map(MyAppointmentsAction.workSlotsResponse)
    case .workSlotsResponse(.success(let workSlots)):
        state.workSlots = Dictionary(uniqueKeysWithValues: workSlots.map { ($0.id, $0) })
        return Effect(value: MyAppointmentsAction.workSlotsUpdated)
    case .workSlotsUpdated:
        if let workSlots = state.workSlots?.map { $0.value } {
            state.appointments = workSlots.filter { [WorkSlot.Status.booked, WorkSlot.Status.confirmed].contains($0.status) && ($0.customerId == state.patientUuid) && ($0.beginDateTime >= Date()) }
            state.history = workSlots.filter { [WorkSlot.Status.booked, WorkSlot.Status.confirmed].contains($0.status) && ($0.customerId == state.patientUuid) && ($0.beginDateTime < Date()) }
                .sorted(by: { $0.date.isAfterDate($1.date, granularity: .day)})
            print(state.history?.count ?? 0)
        }
        return .none
    case .workSlotsResponse(.failure(_)):
        // TODO process errors
        return .none
    case .editTapped(let appointment):
        state.editAppointmentState = EditAppointmentState(appointment: appointment, text: appointment.description ?? "")
        print(appointment.id)
        return .none
    case .alertDismissed:
        state.alert = nil
        return .none
    case let .editAppointment(.deleteAppointment(appointment)):
        if let appointment = appointment {
            state.canceledAppointments.append(appointment)
        }
        return .none
    case .editAppointmentDismissed, .editAppointment(.cancel):
        state.editAppointmentState = nil
        return .none
    case .editAppointment(.updateAppointmentResponse(.success(_))):
        state.alert = .init(title: .init(R.string.localizable.myAppointmentsEditTextMessage()))
        state.editAppointmentState = nil
        return Effect(value: MyAppointmentsAction.getDoctorWorkSlots)
    case let .editAppointment(.updateAppointmentResponse(.failure(error))):
        state.alert = .init(title: .init(error.localizedDescription))
        state.editAppointmentState = nil
        return .none
    case .editAppointment(.deleteAppointmentResponse(.success(_))):
        state.editAppointmentState = nil
        state.alert = .init(title: .init(R.string.localizable.myAppointmentsCancelMessage()))
        return Effect(value: MyAppointmentsAction.getDoctorWorkSlots)
    case let .editAppointment(.deleteAppointmentResponse(.failure(error))):
        state.editAppointmentState = nil
        state.alert = .init(title: .init(error.localizedDescription))
        return .none
    case let .cancelAppointment(id):
        state.canceledAppointments = state.canceledAppointments.filter { $0.id != id }
        return .none
    default:
        return .none
    }
})
