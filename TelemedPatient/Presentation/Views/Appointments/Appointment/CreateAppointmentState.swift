//
// Created by Андрей Кривобок on 15.01.2021.
//

import ComposableArchitecture

struct CreateAppointmentState: Equatable {
    var patientProfile: PatientProfile
    var doctorProfile: DoctorProfile
    var timeSlot: TimeSlot
    var text: String = ""
    var appointmentCreated = false
}
