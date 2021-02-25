//
// Created by Андрей Кривобок on 17.12.2020.
//

import SwiftUI
import ComposableArchitecture
import SocketIO

fileprivate struct DoctorProfileInfoView: View {
    
    let doctorProfile: DoctorProfile
    
    private struct DoctorProfilePhotoView: View {
        var photoURL: String?
        
        var body: some View {
            if let url = photoURL {
                UrlImageView(url: url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
            }
            else {
                Image("avatar")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                DoctorProfilePhotoView(photoURL: doctorProfile.photo?.link)
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(R.color.lightGray()), lineWidth: 0.5))

                VStack(alignment: .leading) {
                    Text(doctorProfile.name ?? "").font(.system(size: 20))
                                                                .padding(10)
                    if let specialty = doctorProfile.specialty, specialty != "" {
                        Text(specialty).font(.system(size: 16))
                            .foregroundColor(Color(R.color.blackLabel()))
                            .padding(.leading, 10)
                        Spacer().frame(height: 10)
                    }
                    if let city = doctorProfile.city, city != "" {
                        Text(R.string.localizable.profileCityTitle(city)).font(.system(size: 14))
                            .foregroundColor(Color(R.color.blackLabel()))
                            .padding(.leading, 10)
                        Spacer().frame(height: 4)
                    }
                    if let birthday = doctorProfile.birthday, birthday != "" {
                        Text(birthday).font(.system(size: 14))
                            .foregroundColor(Color(R.color.blackLabel()))
                            .padding(.leading, 10)
                    }
                    Spacer().frame(height: 10)
                }
                Spacer()
            }.padding(.leading, 10)
            Group {
            doctorProfile.qualification.map {
                Text(R.string.localizable.appointmentsQualification() + $0)
                    .foregroundColor(Color(R.color.blackLabel()))
            }
            doctorProfile.seniority.map {
                Text(R.string.localizable.appointmentsSeniority() + $0)
                    .foregroundColor(Color(R.color.blackLabel()))
            }
            doctorProfile.aboutMe.map {
                Text($0)
                    .foregroundColor(Color(R.color.blackLabel()))
            }
            }.padding(.leading, 10)
            Spacer().frame(height: 10)
        }
    }
}


struct AppointmentsView: View {
    
    struct ViewState: Equatable {
        var createAppointmentPresented = false
    }

    enum ViewAction {

    }

    @State var createAppointmentPresented = false

    let store: Store<AppointmentsState, AppointmentsAction>

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
                        if let profile = viewStore.doctorProfile {
                            DoctorProfileInfoView(doctorProfile: profile)
                                .padding(.trailing)
                        }
                        if let schedule = viewStore.schedule {
                            VStack {
                                ForEach(schedule.sections, id: \.self) { section in
                                    Button(action: {
                                        viewStore.send(AppointmentsAction.scheduleSectionTapped(section))
                                    }, label: {
                                        Group {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(section.title.uppercased()).font(.system(size: 14))
                                                    Text(section.duration.uppercased()).font(.system(size: 14))
                                                }.padding().foregroundColor(.white)
                                                Spacer()
                                            }
                                        }
                                        .frame(maxWidth: .infinity, idealHeight: 52, maxHeight: 52)
                                        .background(Color(R.color.silverTree()))
                                        .cornerRadius(10)
                                        .padding(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                                    })
                                    if section.id == viewStore.expandedSectionId {
                                        let columns = Array(repeating: GridItem(.adaptive(minimum: 100)), count: 4)
                                        LazyVGrid(columns: columns, alignment: .center, spacing: 10, pinnedViews: [.sectionHeaders]) {
                                            ForEach(section.dateSlots, id: \.self) { dateSlot in
                                                Section(header: VStack{
                                                    Text(dateSlot.dateString.capitalized).fontWeight(.medium)
                                                    Text(dateSlot.description).fontWeight(.light)
                                                }
                                                .foregroundColor(Color(R.color.blackLabel()))
                                                .background(Color.white)
                                                ) {
                                                    ForEach(dateSlot.timeSlots, id: \.self) { timeSlot in
                                                        Button(action: {
                                                            viewStore.send(AppointmentsAction.timeSlotSelected(timeSlot))
                                                            createAppointmentPresented = true // TODO: use state
                                                        }, label: {
                                                            Text(timeSlot.start.toString(.time(.short)))
                                                                .foregroundColor(Color(R.color.blackLabel()))
                                                                .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                                                        })
                                                        .border(Color(R.color.cornflowerBlue()), width: 1)
                                                    }
                                                }
                                            }
                                        }.padding()
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
                }.sheet(isPresented: viewStore.binding(get: { $0.view.createAppointmentPresented }, send: AppointmentsAction.createAppointmentDismissed)) {
                    IfLetStore(store.scope (state: { $0.createAppointmentState }, action: AppointmentsAction.createAppointment)) { store in
                        CreateAppointmentView(store: store)
                    }
                }
            }
            .navigationBarTitle(R.string.localizable.appointmentsTitle(), displayMode: .inline)
        }
        .onAppear {
            ViewStore(store).send(.didAppear)
            ViewStore(store).send(.getDoctorWorkSlots) // TODO: move to reducer`s didAppear case
        }
        }
    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView(
            store: Store<AppointmentsState, AppointmentsAction>(
                initialState: AppointmentsState(
                        patientProfile: PatientProfile(
                                allergy: "",
                                birthday: "",
                                city: "",
                                email: "",
                                id: 0,
                                lastDoctorNickname: "",
                                name: "",
                                ownerId: "",
                                phone: "",
                                photo: nil,
                                specialty: ""),
                    doctorProfile: DoctorProfile(
                        id: 0,
                        ownerId: "bf71e462-1e4d-4d60-800d-9e7ae7641c76", name: "Кривобок",
                        specialty: "Терапевт",
                        services: [
                            Service(id: 0, name: "Онлайн консультация", price: 2000, enabled: true, iconName: nil, duration: 30),
                            Service(id: 0, name: "Консультация по телефону", price: 2000, enabled: true, iconName: nil, duration: 30)
                        ]
                    )
                ),
                reducer: appointmentsReducer,
                environment: AppointmentsEnvironment(
                        workSlotsClient: .live,
                        socketClient: .live,
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        progressHUD: ProgressHUDPresenter()
                )
            )
        )
    }
}
