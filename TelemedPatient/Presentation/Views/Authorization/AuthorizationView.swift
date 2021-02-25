//
// Created by Андрей Кривобок on 13.11.2020.
//

import SwiftUI
import ComposableArchitecture
import Hue

struct AuthorizationView: View {

    let store: Store<AuthorizationState, AuthorizationAction>

    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                NavigationView {
                ZStack() {
                    ZStack() {
                        Image("background")
                                .resizable(resizingMode: .tile)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Group {
                                    let doctorName = viewStore.doctorProfile.name ?? ""
                                    switch viewStore.state.mode {
                                    case .login:
                                        Text(R.string.localizable.authorizationSignInTitle(doctorName))
                                    case .signUp:
                                        Text(R.string.localizable.authorizationSignUpTitle(doctorName))
                                    }
                                }
                                .font(.system(size: 14))
                                .padding(.trailing, -35)
                                .lineLimit(nil)
                                
                                Image("doctor")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, -8)
                            .padding(.top, 20)

                            currentContentView(for: viewStore.state.mode)
                            
                            Button(action: {
                                viewStore.send(.switchMode)
                            }, label: {
                                HStack() {
                                    Text(R.string.localizable.authorizationOr()).foregroundColor(.black)
                                    switch viewStore.state.mode {
                                    case .login:
                                        Text(R.string.localizable.authorizationSignUp()).underline()
                                                .foregroundColor(Color(R.color.cornflowerBlue()))
                                    case .signUp:
                                        Text(R.string.localizable.authorizationSignInOffer()).underline()
                                                .foregroundColor(Color(R.color.cornflowerBlue()))
                                    }
                                }
                            }).padding(.top, 20)
                            .padding(.bottom, 10)
                        }.padding(16)
                        .background(Color.white)
                        .cornerRadius(4)
                        .shadow(radius: 1)
                        .frame(width: geometry.size.width * 0.75, height: 50, alignment: .center)
                    }.edgesIgnoringSafeArea(.all)
                }.onAppear() {
                    viewStore.send(.getDoctorProfile)
                }
                }
            }
        }
    }

    init(store: Store<AuthorizationState, AuthorizationAction>) {
        self.store = store
        UINavigationBar.appearance().tintColor = UIColor.black
    }

    private func currentContentView(for mode: AuthorizationState.Mode) -> AnyView {
        switch mode {
        case .login:
            return AnyView(IfLetStore(store.scope(state: { $0.loginState }, action: AuthorizationAction.login)) { store in
                LoginView(store: store)
            })
        case .signUp:
            return AnyView(IfLetStore(store.scope(state: { $0.signUpState }, action: AuthorizationAction.signUp)) { store in
                SignUpView(store: store)
            })
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(store: Store<AuthorizationState, AuthorizationAction>(
                initialState: AuthorizationState(
                        mode: .login(LoginState()),
                        doctorProfile: DoctorProfile(
                                id: -1,
                                ownerId: "",
                                name: "Иванов Иван Иванович",
                                specialty: "Терапевт",
                                city: "Новосибирск",
                                phone: "+71111111111",
                                seniority: nil,
                                email: nil,
                                aboutMe: nil,
                                qualification: nil,
                                birthday: nil,
                                photo: nil)),
                reducer: authorizationReducer,
                environment: AuthorizationEnvironment(
                        authorizationClient: .live,
                        doctorProfileClient: .live,
                        profileClient:.live,
                        resetPasswordClient: .live,
                        feedbackClient: .live,
                        secureStorage: ValetStorageService(),
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        progressHUD: ProgressHUDPresenter())))
            .previewDevice("iPhone 8")
    }
}
