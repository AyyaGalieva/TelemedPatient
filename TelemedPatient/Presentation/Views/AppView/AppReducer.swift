//
// Created by Андрей Кривобок on 16.12.2020.
//

import Foundation
import ComposableArchitecture
import UIKit

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(

        authorizationReducer.optional().pullback(
                state: \.authorizationState,
                action: /AppAction.authorization,
                environment: {
                    AuthorizationEnvironment(
                            authorizationClient: $0.authorizationClient,
                            doctorProfileClient: $0.doctorProfileClient,
                            profileClient: $0.profileClient,
                            resetPasswordClient: $0.resetPasswordClient,
                            feedbackClient: $0.feedbackClient,
                            secureStorage: $0.secureStorage,
                            mainQueue: $0.mainQueue,
                            progressHUD: $0.progressHUD
                    )
                }
        ),
        appointmentsReducer.optional().pullback(
                state: \.appointmentsState,
                action: /AppAction.appointments,
                environment: {
                    AppointmentsEnvironment(
                            workSlotsClient: $0.workSlotsClient,
                            socketClient: $0.socketClient,
                            mainQueue: $0.mainQueue,
                            progressHUD: $0.progressHUD)
                }
        ),
    myAppointmentsReducer.optional().pullback(
            state: \.myAppointmentsState,
            action: /AppAction.myAppointments,
            environment: {
                MyAppointmentsEnvironment(
                        workSlotsClient: $0.workSlotsClient,
                        mainQueue: $0.mainQueue,
                        progressHUD: $0.progressHUD
                )
            }
    ),
        medicalCardReducer.optional().pullback(
            state: \.medicalCardState,
            action: /AppAction.medicalCard,
            environment: {
                MedicalCardEnvironment(
                    medicalCardClient: $0.medicalCardClient,
                    mainQueue: $0.mainQueue,
                    progressHUD: $0.progressHUD)
            }
        ),
        profileReducer.optional().pullback(
                state: \.profileState,
                action: /AppAction.profile,
                environment: {
                    ProfileEnvironment(profileClient: .live, feedbackClient: .live, mainQueue: $0.mainQueue, progressHUD: $0.progressHUD)
                }),

        Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
            switch action {
            case let .authorization(.authorized(token, patientProfile)),
                 let .authorizationRestored(token, profile: patientProfile):
                guard let doctorProfile = state.doctorProfile else { fatalError("doctor profile not loaded") }
                state.appAuthorizationState = .authorized(token)
                state.patientProfile = patientProfile
                environment.setProfileID(patientProfile.id)
                return Effect.concatenate(
                        Effect.fireAndForget {
                            environment.secureStorage.save(value: token, key: AppEnvironment.authorizationTokenKey)
                        },
                        environment.doctorProfileClient
                                .addPatient(AddPatientRequest(doctorID: doctorProfile.id, patientID: patientProfile.id))
                                .delay(for: 0.5, scheduler: environment.mainQueue)
                                .receive(on: environment.mainQueue)
                                .catchToEffect()
                                .map(AppAction.addPatientResponse)
                )
            case .nonAuthorized(let doctorProfile):
                state.appAuthorizationState = .nonAuthorized(AuthorizationState(mode: .login(LoginState()), doctorProfile: doctorProfile))
                return Effect.fireAndForget {
                    environment.secureStorage.save(value: nil, key: AppEnvironment.authorizationTokenKey) //TODO: extract constant, extract effect??
                }
            case let .restoreAuthorization(token, profileID):
                state.appAuthorizationState = .authorizationRestoration(token, profileID: profileID)
                return environment.profileClient
                        .getProfile(profileID)
                        .catchToEffect()
                        .map(AppAction.profileLoaded)
            case .profileLoaded(.success(let profile)):
                if case let AppAuthorizationState.authorizationRestoration(token, profileID) = state.appAuthorizationState {
                    return Effect(value: AppAction.authorizationRestored(token, profile: profile))
                }
                return .none
            case .profileLoaded(.failure(let error)):
                print(error)
                return .none
            case .addPatientResponse(.success(_)):
                guard let patientProfile = state.patientProfile else { fatalError() }
                state.profileState = ProfileState(with: patientProfile)
                guard let doctorProfile = state.doctorProfile else {
                    fatalError("doctor profile not loaded")
                }
                state.appointmentsState = AppointmentsState(patientProfile: patientProfile, doctorProfile: doctorProfile)
                state.medicalCardState = MedicalCardState(ownerId: patientProfile.ownerId)
                state.myAppointmentsState = MyAppointmentsState(doctorID: doctorProfile.ownerId, patientUuid: patientProfile.ownerId)
                return environment
                    .socketClient
                    .connect(SocketRoom(ownerId: patientProfile.ownerId, roomId: doctorProfile.ownerId))
                    .fireAndForget()
            case .openDoctorLink(let doctorLink):
                let doctorNickname = doctorLink.lastPathComponent
                return environment
                        .doctorProfileClient
                        .getDoctorProfileByNickname(doctorNickname)
                        .receive(on: environment.mainQueue)
                        .delay(for: .seconds(0.5), scheduler: environment.mainQueue)
                        .catchToEffect()
                        .map(AppAction.doctorProfileResponse)
            case .doctorProfileResponse(.success(let doctorProfile)):
                state.doctorProfile = doctorProfile

                if let token = environment.authorizationToken, let profileID = environment.profileID {
                    return Effect(value: AppAction.restoreAuthorization(token, profileID: profileID))
                } else {
                    return Effect(value: AppAction.nonAuthorized(doctorProfile: doctorProfile))
                }
            case .profile(.logout):
                guard let doctorProfile = state.doctorProfile else {
                    fatalError("doctor profile not loaded")
                }
                state.appAuthorizationState = .nonAuthorized(AuthorizationState(mode: .login(LoginState()), doctorProfile: doctorProfile))
                return Effect.fireAndForget {
                    environment.setToken(nil)
                    environment.setProfileID(nil)
                }
            case .appointments(.workSlotsUpdated):
                state.appointmentsBadge = state.appointmentsState?.badgeNumber ?? 0
                return .none
            default:
                return .none
            }
        }
)
