//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum AppAction {
    case workflow
    case restoreAuthorization(_ token: String, profileID: Int)
    case authorizationRestored(_ token: String, profile: PatientProfile)
    case profileLoaded(_ response: Result<PatientProfile, ProfileAPI.Error>)
    case authorized(_ token: String, profile: PatientProfile)
    case nonAuthorized(doctorProfile: DoctorProfile)
    case authorization(_ authorizationAction: AuthorizationAction)
    case appointments(_ appointmentsAction: AppointmentsAction)
    case myAppointments(_ myAppointmentsAction: MyAppointmentsAction)
    case medicalCard(_ midecalCardAction: MedicalCardAction)
    case openDoctorLink(_ doctorLink: URL)
    case profile(_ profileAction: ProfileAction)
    case getDoctorProfile(_ doctorLink: URL)
    case doctorProfileResponse(_ response: Result<DoctorProfile, DoctorProfileAPI.Error>)
    case addPatientResponse(_ response: Result<Empty, ProfileAPI.Error>)
}
