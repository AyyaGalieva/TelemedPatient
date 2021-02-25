//
//  ContentView.swift
//  TelemedPatient
//
//  Created by Андрей Кривобок on 12.11.2020.
//
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @State private var tabSelection = 1

    let store: Store<AppState, AppAction>
    
    private var tabsCount: CGFloat = 4
    private var badgePosition: CGFloat = 2

    init(store: Store<AppState, AppAction>) {
        self.store = store
        UINavigationBar.appearance().barTintColor = R.color.cornflowerBlue()
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            currentView(for: viewStore.appAuthorizationState)
            .onOpenURL { url in
                viewStore.send(.openDoctorLink(url))
            }
        }
    }
    
    private func profileView() -> some View {
        return AnyView(IfLetStore(store.scope(state: { $0.profileState }, action: AppAction.profile), then: { store in
            ProfileView(store: store)
        }, else: EmptyView()))
    }

    private func badgeView(geometryWidth: CGFloat, appointmentsBadge: Int) -> some View {
        return ZStack {
            Circle()
                .foregroundColor(.orange)
            Text("\(appointmentsBadge)")
                        .foregroundColor(.white)
                        .font(Font.system(size: 12))
        }.frame(width: 15, height: 15)
        .offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometryWidth / ( 2 * self.tabsCount ) ) + 14, y: -26)
        .opacity(appointmentsBadge == 0 ? 0 : 1.0)
    }

    func currentView(for authorizationState: AppAuthorizationState) -> some View {
        switch authorizationState {
        case .unknown, .authorizationRestoration:
            return AnyView(
                VStack(){
                    Text("Здесь будет доступ к списку врачей, но он пока не реализован.").padding()
                    Text("Для авторизации откройте приложение через ссылку вида:").padding()
                    Link("telemed://primet.online/{doctor}", destination: URL(string: "telemed://primu.online/Krivobok")!)
                })
        case .authorized:
            return AnyView(
                    WithViewStore(store) { viewStore in
                        GeometryReader { geometry in
                            ZStack (alignment: .bottomLeading){
                                TabView(selection: $tabSelection) {
                                    IfLetStore(store.scope(state: { $0.appointmentsState }, action: AppAction.appointments)) { store in
                                            AppointmentsView(store: store)
                                        }
                                        .tabItem {
                                            Image(R.image.tabbarAppointments())
                                            Text(R.string.localizable.mainSignUpTab())
                                        }.tag(1)
                                    IfLetStore(store.scope(state: { $0.myAppointmentsState }, action: AppAction.myAppointments)) { store in
                                        MyAppointmentsView(tabSelection: $tabSelection, store: store)
                                        }
                                    .tabItem {
                                        Image(R.image.tabbarMyAppointments())
                                        Text(R.string.localizable.myAppointmentsTitle())
                                    }.tag(2)
                                        IfLetStore(store.scope(state: { $0.medicalCardState }, action: AppAction.medicalCard)) { store in
                                                MedicalCardView(store: store)
                                            }
                                        .tabItem {
                                            Image(R.image.tabbarMedcard())
                                            Text(R.string.localizable.mainMedicalCardTab())
                                        }.tag(3)
                                        VStack{
                                            profileView()
                                        }.tabItem {
                                            Image(R.image.tabbarProfile())
                                            Text(R.string.localizable.mainProfileTab())
                                        }.tag(4)
                                }

                                if viewStore.appointmentsBadge != 0 {
                                    badgeView(geometryWidth: geometry.size.width, appointmentsBadge: viewStore.appointmentsBadge)
                                }
                            }
                        }
                    }
            )
        case .nonAuthorized:
            return AnyView(IfLetStore(store.scope(state: { $0.authorizationState }, action: AppAction.authorization), then: { store in
                AuthorizationView(store: store)
            }, else: EmptyView()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: Store<AppState, AppAction>(initialState: AppState(appAuthorizationState: .authorized("")),
                reducer: appReducer, environment: AppEnvironment.live)) //TODO replace by DEBUG environment
    }
}
