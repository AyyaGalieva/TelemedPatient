//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation

enum AuthorizationAction {
    case switchMode
    case login(_ loginAction: LoginAction)
    case signUp(_ signUpAction: SignUpAction)
    case getDoctorProfile
    case doctorProfileResponse(_ response: Result<DoctorProfile, DoctorProfileAPI.Error>)
    case authorized(_ token: String, profile: PatientProfile)
}
