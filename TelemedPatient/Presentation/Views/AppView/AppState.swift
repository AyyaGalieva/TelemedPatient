//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum AppAuthorizationState: Equatable {
    case unknown
    case nonAuthorized(_ mode: AuthorizationState)
    case authorized(_ token: String)
    case authorizationRestoration(_ token: String, profileID: Int)
}

struct AppState: Equatable {
    var appAuthorizationState: AppAuthorizationState
    var patientProfile: PatientProfile?
    var doctorProfile: DoctorProfile?
    var appointmentsState: AppointmentsState?
    var myAppointmentsState: MyAppointmentsState?
    var medicalCardState: MedicalCardState?
    var profileState: ProfileState?
    var appointmentsBadge = 0
}

extension AppState {
    var authorizationState: AuthorizationState? {
        get {
            switch appAuthorizationState {
            case .nonAuthorized(let authorizationState):
                return authorizationState
            default:
                return nil
            }
        }
        set {
            guard let doctorProfile = doctorProfile else { fatalError("doctor profile not loaded") }
            appAuthorizationState = .nonAuthorized(newValue ?? AuthorizationState(mode: .login(LoginState()), doctorProfile: doctorProfile))
        }
    }
}
