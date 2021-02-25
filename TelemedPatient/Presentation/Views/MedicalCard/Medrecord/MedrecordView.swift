//
//  MedrecordView.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 21.12.2020.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct MedrecordView: View {

    struct ViewState: Equatable {
        
        var medrecord: Medrecord
        var costString: String
        var filesNameString: String
    }
    
    enum ViewAction {
        case medrecordDateChanged(_ medrecordDate: String)
        case doctorFullNameChanged(_ doctorFullName: String)
        case doctorSpecialtyChanged(_ doctorSpecialty: String)
        case anamnesisChanged(_ anamnesis: String)
        case diagnosisChanged(_ diagnosis: String)
        case treatmentChanged(_ treatment: String)
        case imageFileAttached(_ image: NamedUIImage)
        case costChanged(_ cost: String)
        case saveButtonTapped(_ presentationMode: Binding<PresentationMode>)
        case deleteButtonTapped(_ presentationMode: Binding<PresentationMode>)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    let store: Store<MedrecordState, MedrecordAction>
    
    var body: some View {
        WithViewStore(store.scope(state: { $0.view }, action: MedrecordAction.view)) { viewStore in
            ZStack {
                ScrollView {
                    VStack(spacing: 30) {
                        FloatingTextField(R.string.localizable.medicalCardDate(),
                                          text: viewStore.binding( get: { $0.medrecord.longFormatDate },
                                                                   send: ViewAction.medrecordDateChanged)
                        ).borderType(.bottomLine)
                        .leftImage(Image(R.image.medrecordDate()))
                        .inputType(.date)
                        
                        FloatingTextField(R.string.localizable.medicalCardDoctorFullName(),
                                          text: viewStore.binding( get: { $0.medrecord.doctorName },
                                                                   send: ViewAction.doctorFullNameChanged)
                        ).borderType(.bottomLine)
                        .leftImage(Image(R.image.medrecordPerson()))
                        
                        Group {
                            FloatingTextField(R.string.localizable.medicalCardSpecialty(),
                                              text: viewStore.binding( get: { $0.medrecord.doctorSpecialty },
                                                                       send: ViewAction.doctorSpecialtyChanged)
                            ).borderType(.bottomLine)
                            
                            FloatingTextField(R.string.localizable.medicalCardAnamnesis(),
                                              text: viewStore.binding( get: { $0.medrecord.anamnesis },
                                                                       send: ViewAction.anamnesisChanged)
                            ).borderType(.bottomLine)
                            
                            FloatingTextField(R.string.localizable.medicalCardDiagnosis(),
                                              text: viewStore.binding( get: { $0.medrecord.diagnosis },
                                                                       send: ViewAction.diagnosisChanged)
                            ).borderType(.bottomLine)
                            
                            FloatingTextField(R.string.localizable.medicalCardTreatment(),
                                              text: viewStore.binding( get: { $0.medrecord.treatment },
                                                                       send: ViewAction.treatmentChanged)
                            ).borderType(.bottomLine)
                        }.padding(.leading, 20)
                        
                        FloatingTextField(R.string.localizable.medicalCardAttachFiles(),
                                          text: Binding(get: {
                                            viewStore.filesNameString
                                          }, set: { _ in
                                            
                                          }),
                                          onImagePickerDismiss:  { uiImage in
                                            viewStore.send(ViewAction.imageFileAttached(uiImage))
                        }).borderType(.bottomLine)
                        .leftImage(Image(R.image.medrecordPaperclip()))
                        .inputType(.image)
                                            
                        FloatingTextField(R.string.localizable.medicalCardCost(),
                                          text: viewStore.binding( get: { $0.costString },
                                                                   send: ViewAction.costChanged)
                        ).borderType(.bottomLine)
                        .leftImage(Image(R.image.medrecordRuble()))
                        
                        Button(action: {
                            viewStore.send(.saveButtonTapped(presentationMode))
                        }, label: {
                            ImageWithTextHStack(uiImage: R.image.medrecordSave(),
                                                text: R.string.localizable.medicalCardSave())
                        }).buttonStyle(TelemedButtonStyle(backgroundColor: R.color.acapulco()))
                        .disabled(!viewStore.medrecord.isValid)
                        
                        if viewStore.medrecord.id != nil {
                            Button(action: {
                                viewStore.send(.deleteButtonTapped(presentationMode))
                            }, label: {
                                ImageWithTextHStack(uiImage: R.image.medrecordCancel(),
                                                    text: R.string.localizable.medicalCardDelete())
                            }).buttonStyle(TelemedButtonStyle(backgroundColor: R.color.valencia()))
                        }
                    }.padding([.bottom, .leading, .trailing], 12)
                }
            }
        }
    }
}

struct MedrecordView_Previews: PreviewProvider {
    static var previews: some View {
        MedrecordView(store: Store<MedrecordState, MedrecordAction>(
            initialState: MedrecordState(with: Medrecord.mock),
            reducer: medrecordReducer,
            environment: MedrecordEnvironment.live
        ))
    }
}
