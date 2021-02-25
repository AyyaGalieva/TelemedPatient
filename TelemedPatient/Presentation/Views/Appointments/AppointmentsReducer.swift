//
// Created by Андрей Кривобок on 17.12.2020.
//

import ComposableArchitecture
import SwiftDate

let appointmentsReducer = Reducer<AppointmentsState, AppointmentsAction, AppointmentsEnvironment>.combine(
        createAppointmentReducer.optional().pullback(
                state: \.createAppointmentState,
                action: /AppointmentsAction.createAppointment,
                environment: {
                    CreateAppointmentEnvironment(workSlotsClient: $0.workSlotsClient, mainQueue: $0.mainQueue, progressHUD: $0.progressHUD)
                }
            ),
        Reducer<AppointmentsState, AppointmentsAction, AppointmentsEnvironment> { state, action, environment in
            switch action {
            case .didAppear:
                state.schedule = Schedule(services: state.doctorProfile.services, workSlots: [])
                return environment
                        .socketClient
                        .onWorkSlotUpdated()
                        .eraseToEffect()
                        .map(AppointmentsAction.workSlotUpdated)
            case .getDoctorWorkSlots:
                return environment
                        .workSlotsClient
                        .getWorkSlots(GetWorkSlotsRequest(owner: state.doctorProfile.ownerId, begin: Date()))
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(AppointmentsAction.workSlotsResponse)
            case .workSlotsResponse(.success(let workSlots)):
                state.workSlots = Dictionary(uniqueKeysWithValues: workSlots.map { ($0.id, $0) })
                return Effect(value: AppointmentsAction.workSlotsUpdated)
            case .workSlotsUpdated:
                if let workSlots = state.workSlots?.map { $0.value } {
                    state.schedule = Schedule(services: state.doctorProfile.services, workSlots: workSlots)
                    state.appointments = workSlots.filter { [WorkSlot.Status.booked, WorkSlot.Status.confirmed].contains($0.status) && ($0.customerId == state.patientProfile.ownerId) }
                }
                state.badgeNumber = state.appointments?.count ?? 0
                return .none
            case .workSlotsResponse(.failure):
                // TODO process errors
                return .none
            case .timeSlotSelected(let timeSlot):
                state.selectedTimeSlot = timeSlot
                
                if let timeSlot = timeSlot {
                    state.createAppointmentState = CreateAppointmentState(patientProfile: state.patientProfile,
                            doctorProfile: state.doctorProfile,
                            timeSlot: timeSlot)
                }
                return .none
            case .createAppointment(.createAppointmentResponse(.success(_))):
                state.selectedTimeSlot = nil
                state.createAppointmentState = nil
                return Effect(value: AppointmentsAction.getDoctorWorkSlots)
            case .workSlotUpdated(let workSlot):
                state.workSlots?[workSlot.id] = workSlot
                return Effect(value: AppointmentsAction.workSlotsUpdated)
            case .scheduleSectionTapped(let section):
                state.expandedSectionId = section.id
                return .none
            case .createAppointmentDismissed, .createAppointment(.cancel):
                state.createAppointmentState = nil
                return .none
            default:
                return .none
            }
        }
)
