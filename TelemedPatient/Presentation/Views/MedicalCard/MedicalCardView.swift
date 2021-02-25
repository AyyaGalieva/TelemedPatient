//
//  MedicalCardView.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 15.12.2020.
//

import SwiftUI
import ComposableArchitecture

struct MedicalCardView: View {

    private struct Constants {
        static let buttonImageEdge: CGFloat = 24
        static let bottomOffset: CGFloat = 138
    }
    
    let store: Store<MedicalCardState, MedicalCardAction>

    init(store: Store<MedicalCardState, MedicalCardAction>) {
        self.store = store
        UITableView.appearance().backgroundColor = UIColor.clear
    }

    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                NavigationView {
                    ZStack() {
                        Image("background")
                                .resizable(resizingMode: .tile)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                        VStack(alignment: .trailing) {
                            List {
                                ForEachStore(store.scope(state: { $0.medrecordStates },
                                                         action: MedicalCardAction.idMedrecord(id:medrecordAction:)),
                                             content: { store in
                                                WithViewStore(store) { medrecordViewStore in
                                                    HStack {
                                                        MedrecordShortView(note: ShortMedrecord(medrecordViewStore.medrecord))
                                                            .cornerRadius(4)
                                                            .frame(maxWidth: .infinity,
                                                                   maxHeight: .infinity,
                                                                   alignment: .leading)
                                                        
                                                        NavigationLink(
                                                            destination: MedrecordView(store: store),
                                                            label: {
                                                                EmptyView()
                                                        }).frame(width: 0)
                                                            .listRowBackground(Color.green)

                                                        Spacer()
                                                    }
                                                }
                                             }
                                )
                            }
                        }.background(Color.white)
                        .cornerRadius(4)
                        .shadow(radius: 1)
                        .frame(width: geometry.size.width * 0.85, height: geometry.size.height - Constants.bottomOffset, alignment: .top)
                        .navigationBarTitle(R.string.localizable.medicalCardTitle(), displayMode: .inline)
                        .padding(.top, -(Constants.bottomOffset/2))

                        VStack {
                            Spacer()
                            
                            IfLetStore(store.scope(state: { $0.newMedrecordState },
                                                   action: MedicalCardAction.medrecord)) { store in
                                NavigationLink(destination: MedrecordView(store: store),
                                    label: {
                                    ImageWithTextHStack(uiImage: R.image.commonPlus(), text: R.string.localizable.medicalCardAddMedrecord())
                                })
                                .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.acapulco()))
                                .padding(EdgeInsets(top: 0,
                                                    leading: 16,
                                                    bottom: 100,
                                                    trailing: 16))
                            }
                        }
                    }
                }.onAppear {
                    UITableView.appearance().separatorStyle = .none
                    ViewStore(store).send(.fetchMedrecords)
                }
            }
        }
    }
}

struct MedicalCardView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalCardView(store: Store<MedicalCardState, MedicalCardAction>(
            initialState: MedicalCardState(ownerId: "24b8d2e3-8d90-42f7-b18f-a3d9a792a25a",
                                           medrecordStates: IdentifiedArrayOf<MedrecordState>(arrayLiteral: MedrecordState(with: Medrecord.mock), MedrecordState(with: Medrecord.mock))),
            reducer: medicalCardReducer,
            environment: MedicalCardEnvironment(
                    medicalCardClient: .live,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    progressHUD: ProgressHUDPresenter()
            )
        ))
    }
}
