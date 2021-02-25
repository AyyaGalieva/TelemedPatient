//
//  MyAppointmentsView.swift
//  TelemedPatient
//
//  Created by Galieva on 07.02.2021.
//

import SwiftUI
import ComposableArchitecture

struct MyAppointmentsView: View {
    
    @Binding var tabSelection: Int

    struct ViewState: Equatable {
        var editAppointmentPresented = false
    }
    
    let store: Store<MyAppointmentsState, MyAppointmentsAction>

    @State var editAppointmentPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
            WithViewStore(store) { viewStore in
                ScrollView {
                    ZStack(alignment: .top) {
                        Image("background")
                                .resizable(resizingMode: .tile)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                        VStack(alignment: .trailing, spacing: 10) {
                            HStack {
                                Spacer()
                            }
                            if let canceledAppointments = viewStore.canceledAppointments {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(canceledAppointments, id: \.id) { appointment in
                                        removedAppointmentView(for: appointment, viewStore: viewStore)
                                    }
                                }
                            }
                            if let appointments = viewStore.appointments {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(appointments, id: \.id) { appointment in
                                        appointmentView(for: appointment, viewStore: viewStore)
                                    }
                                    if let history = viewStore.history, history.count > 0 {
                                        Text(R.string.localizable.myAppointmentsHistory())
                                                                                .font(.system(size: 16))

                                        ForEach(history, id: \.id) { appointment in
                                            historyView(for: appointment, viewStore: viewStore)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }.padding(16)
                        .background(Color.white)
                        .cornerRadius(4)
                        .shadow(radius: 1)
                        .frame(width: geometry.size.width * 0.85, alignment: .center)
                    }.edgesIgnoringSafeArea(.horizontal)
                }
                .alert(self.store.scope(state: { $0.alert }), dismiss: .alertDismissed)
                .sheet(isPresented: viewStore.binding(get: { $0.view.editAppointmentPresented }, send: MyAppointmentsAction.editAppointmentDismissed)) {
                    IfLetStore(store.scope (state: { $0.editAppointmentState }, action: MyAppointmentsAction.editAppointment)) { store in
                        EditAppointmentView(store: store)
                    }
                }
                }.navigationBarTitle(R.string.localizable.myAppointmentsTitle(), displayMode: .inline)
            }
            .onAppear {
                ViewStore(store).send(.getDoctorWorkSlots) // TODO: move to reducer`s didAppear case
            }
        }
    }
    
    private func historyView(for appointment: WorkSlot, viewStore: ViewStore<MyAppointmentsState, MyAppointmentsAction>) -> AnyView {
        return AnyView(
            HStack {
                VStack(alignment: .leading) {
                                Text(R.string.localizable.myAppointmentsDone())
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .opacity(0.8)

                                Spacer().frame(height: 20)
                                Text(appointment.appointmentDateTimeString)
                                .foregroundColor(.white)
                                .font(Font.system(size: 20).weight(.bold))
                            }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .shadow(radius: 1)
            .frame(maxWidth: .infinity)
            .background(Color(R.color.lightGray()))
            .cornerRadius(5)
        )
    }
    
    private func removedAppointmentView(for appointment: WorkSlot, viewStore: ViewStore<MyAppointmentsState, MyAppointmentsAction>) -> AnyView {
        switch appointment.status {
        case .booked, .confirmed:
            return AnyView(
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(R.string.localizable.myAppointmentsCancelMessage())
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .opacity(0.8)
                        }
                        Spacer()
                        VStack {
                            Button(action: {
                                viewStore.send(.cancelAppointment(appointment.id))
                            }) {
                                Image(R.image.commonDismiss())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                            }
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                        }

                    }
                    Spacer().frame(height: 20)
                    Text(appointment.appointmentDateTimeString)
                        .foregroundColor(.white)
                        .font(Font.system(size: 20).weight(.bold))
                    Spacer().frame(height: 20)
                    if let description = appointment.description, !description.isEmpty {
                        Text(description)
                            .foregroundColor(.white)
                            .font(Font.system(size: 18).weight(.bold))
                            .opacity(0.8)
                    } else {
                        Text(R.string.localizable.myAppointmentsCanceledByPatient())
                            .foregroundColor(.white)
                            .font(Font.system(size: 18).weight(.bold))
                            .opacity(0.8)
                    }

                    Button(R.string.localizable.myAppointmentsChooseAnotherTime().uppercased()) {
                        self.tabSelection = 1
                    }
                    .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.acapulco()))
                    .padding(.top, 15)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .shadow(radius: 1)
                .frame(maxWidth: .infinity)
                .background(Color(R.color.red()))
                .cornerRadius(5)
            )
        default: return AnyView(EmptyView())
        }
    }

    private func appointmentView(for appointment: WorkSlot, viewStore: ViewStore<MyAppointmentsState, MyAppointmentsAction>) -> AnyView {
        switch appointment.status {
        case .booked, .confirmed:
            return AnyView(
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(R.string.localizable.myAppointmentsYourAppointment() + " " + appointment.status.statusDescription)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .opacity(0.8)
                        }
                        Spacer()
                        VStack {
                            Button(action: {
                                viewStore.send(MyAppointmentsAction.editTapped(appointment))
                                editAppointmentPresented = true
                            }) {
                                Image(R.image.commonEdit())
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                            }
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        }
                    }
                    Spacer().frame(height: 20)
                    Text(appointment.appointmentDateTimeString)
                        .foregroundColor(.white)
                        .font(Font.system(size: 20).weight(.bold))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .shadow(radius: 1)
                .frame(maxWidth: .infinity)
                .background(Color(hex: appointment.color))
                .cornerRadius(5)
            )
        default: return AnyView(EmptyView())
        }
    }
}

extension WorkSlot.Status {
    var statusDescription: String {
        switch self {
        case .booked: return R.string.localizable.myAppointmentsBooked()
        case .confirmed: return R.string.localizable.myAppointmentsConfirmed()
        default: return ""
        }
    }
}
