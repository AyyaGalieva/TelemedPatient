//
//  ProfileView.swift
//  TelemedPatient
//
//  Created by Galieva on 14.12.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Hue

struct ProfileView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: NamedUIImage?
    @State private var selectedImage: Image?
    @State var isFeedbackLinkActive = false
    
    struct ViewState: Equatable {
        var surname: String
        var name: String
        var patronymic: String
        var specialty: String
        var city: String
        var phone: String
        var dateOfBirth: String
        var allergy: String
        var email: String
        var uuid: String
        var photo: Photo?
    }
    
    enum ViewAction {
        case surnameChanged(_ surname: String)
        case nameChanged(_ name: String)
        case patronymicChanged(_ patronymic: String)
        case specialtyChanged(_ specialty: String)
        case cityChanged(_ city: String)
        case dateOfBirthChanged(_ dateOfBirth: String)
        case phoneChanged(_ phone: String)
        case photoChanged(_ photo: UIImage)
        case allergyChanged(_ allergy: String)
        case logoutButtonTapped
    }

    let store: Store<ProfileState, ProfileAction>

    private struct ProfilePhotoView: View {
        
        var photoURL: String?
        var selectedImage: Image?
        
        var body: some View {
            if let url = photoURL, selectedImage == nil {
                UrlImageView(url: url)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
            }
            else if let selectedImage = selectedImage {
                selectedImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
            }
            else {
                Image("avatar")
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store.scope(state: { $0.view }, action: ProfileAction.view)) { viewStore in
                NavigationView {
                    ScrollView {
                        ZStack(alignment: .top) {
                            Image("background")
                                .resizable(resizingMode: .tile)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                            VStack(spacing: 15) {
                                profileSection(viewStore: viewStore)
                                fieldsSection(viewStore: viewStore)
                                buttonsSection(viewStore: viewStore)

                        }.padding(16)
                            .background(Color.white)
                            .cornerRadius(4)
                            .shadow(radius: 1)
                            .frame(width: geometry.size.width * 0.85, alignment: .center)
                        }.edgesIgnoringSafeArea(.all)
                    }.navigationBarTitle(R.string.localizable.profileTitle(), displayMode: .inline)
                    .sheet(isPresented: $showingImagePicker, onDismiss: {
                        guard let inputImage = inputImage else { return }
                        loadImage()
                        viewStore.send(.photoChanged(inputImage.image))
                    }) {
                        ImagePicker(image: self.$inputImage)
                    }
                }
            }
        }
    }

    private func profileSection(viewStore: ViewStore<ViewState, ViewAction>) -> some View {
        return HStack(alignment: .top) {
            ProfilePhotoView(photoURL: viewStore.photo?.link, selectedImage: selectedImage)
                .frame(minWidth: 100)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(R.color.lightGray()), lineWidth: 0.5))
            .onTapGesture {
                self.showingImagePicker = true
            }

            VStack(alignment: .leading) {
                Text(viewStore.state.surname + " " + viewStore.state.name + " " + viewStore.state.patronymic).font(.system(size: 20))
                                                        .padding(10)
                Spacer().frame(height: 10)
                if let specialty = viewStore.state.specialty, specialty != "" {
                    Text(specialty).font(.system(size: 14))
                        .foregroundColor(Color(R.color.blackLabel()))
                        .padding(.leading, 10)
                    Spacer().frame(height: 10)
                }

                if let city = viewStore.state.city, city != "" {
                    Text(R.string.localizable.profileCityTitle(city)).font(.system(size: 14))
                        .foregroundColor(Color(R.color.blackLabel()))
                        .padding(.leading, 10)
                    Spacer().frame(height: 10)
                }
            }

            Spacer()

        }.fixedSize(horizontal: false, vertical: true)
    }

    private func fieldsSection(viewStore: ViewStore<ViewState, ViewAction>) -> some View {
        return VStack(spacing: 15) {
            FloatingTextField(
                R.string.localizable.profileSurname(),
                text: viewStore.binding(get: { $0.surname }, send: ViewAction.surnameChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)

            FloatingTextField(
                R.string.localizable.profileName(),
                text: viewStore.binding(get: { $0.name }, send: ViewAction.nameChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)

            FloatingTextField(
                R.string.localizable.profilePatronymic(),
                text: viewStore.binding(get: { $0.patronymic }, send: ViewAction.patronymicChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)

            FloatingTextField(
                R.string.localizable.profileSpecialty(),
                text: viewStore.binding(get: { $0.specialty }, send: ViewAction.specialtyChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)

            FloatingTextField(
                R.string.localizable.profileCity(),
                text: viewStore.binding(get: { $0.city }, send: ViewAction.cityChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)

            FloatingTextField(
                R.string.localizable.profileDateOfBirth(),
                text: viewStore.binding(get: { $0.dateOfBirth }, send: ViewAction.dateOfBirthChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)
                                .inputType(.date)

            FloatingTextField(
                R.string.localizable.profilePhone(),
                text: viewStore.binding(get: { $0.phone }, send: ViewAction.phoneChanged),
                errorText: .constant(R.string.localizable.errorsWrongPhone()),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
                .autocapitalization(.none)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .maskType(.phone)
            
            FloatingTextField(
                R.string.localizable.profileAllergy(),
                text: viewStore.binding(get: { $0.allergy }, send: ViewAction.allergyChanged),
                onEditingChanged: { isEditing in
                    guard !isEditing else { return }
                }
            ).borderType(.bottomLine)
            .autocapitalization(.none)

            VStack(alignment: .leading) {
                Text(R.string.localizable.profileEmail()).font(.system(size: 14))
                    .foregroundColor(Color(R.color.blackLabel()))

                Text(viewStore.state.email).font(.system(size: 16))
                    .foregroundColor(Color(R.color.lightGray()))

                Spacer().frame(height: 15)

                Text(R.string.localizable.profileUuid()).font(.system(size: 14))
                    .foregroundColor(Color(R.color.blackLabel()))

                Text(viewStore.state.uuid).font(.system(size: 16))
                    .foregroundColor(Color(R.color.lightGray()))
            }
        }

    }

    private func buttonsSection(viewStore: ViewStore<ViewState, ViewAction>) -> some View {
        return Group {
            Button(R.string.localizable.profileLogout().uppercased()) {
                viewStore.send(.logoutButtonTapped)
            }
            .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.red()))
            .padding(.top, 15)

            Button(R.string.localizable.profileNotificationsOn().uppercased()) {
            }
            .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.orange()))
            .padding(.top, 5)

            VStack {
                IfLetStore(store.scope(state: { $0.sendFeedbackState },
                                       action: ProfileAction.feedBack)) { store in
                    NavigationLink(destination: FeedBackView(store: store).padding(20), isActive: $isFeedbackLinkActive) {
                        Button(R.string.localizable.profileFeedBack().uppercased()) {
                            self.isFeedbackLinkActive = true
                        }
                        .buttonStyle(TelemedButtonStyle())
                        .padding(.top, 5)
                    }
                }
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        selectedImage = Image(inputImage.image)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(store: Store<ProfileState, ProfileAction>(
                initialState: ProfileState(surname: "", name: "", patronymic: "", specialty: "", city: "", phone: "", dateOfBirth: "", allergy: "", id: 0),
                reducer: profileReducer,
                environment: ProfileEnvironment(
                        profileClient: .live,
                        feedbackClient: .live,
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        progressHUD: ProgressHUDPresenter()
                )))
            .previewDevice("iPhone 8")
        
        ProfileView(store: Store<ProfileState, ProfileAction>(
                initialState: ProfileState(surname: "", name: "", patronymic: "", specialty: "", city: "", dateOfBirth: "", allergy: "", id: 0),
                reducer: profileReducer,
                environment: ProfileEnvironment(
                        profileClient: .live,
                        feedbackClient: .live,
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        progressHUD: ProgressHUDPresenter()
                )))
            .previewDevice("iPhone 11")
    }
}
