//
// Created by Андрей Кривобок on 17.12.2020.
//

import Foundation

enum AppointmentsAction {
    case didAppear
    case getDoctorWorkSlots
    case workSlotsUpdated
    case workSlotUpdated(workSlot: WorkSlot)
    case workSlotsResponse(_ response: Result<[WorkSlot], DoctorProfileAPI.Error>)
    case timeSlotSelected(_ timeSlot: TimeSlot?)
    case createAppointment(_ createAppointmentAction: CreateAppointmentAction)
    case createAppointmentDismissed
    case scheduleSectionTapped(_ section: ScheduleSection)
}
