//
//  EditAppointmentView.swift
//  TelemedPatient
//
//  Created by Galieva on 10.02.2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Introspect

struct EditAppointmentView: View {
    
    let store: Store<EditAppointmentState, EditAppointmentAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                viewStore.send(.cancel)
                            }) {
                                Image(R.image.commonDismiss())
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                            }
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(R.color.cornflowerBlue()))
                        }

                        Text(R.string.localizable.myAppointmentsAppointmentText())
                            .font(.system(size: 16))

                        TextEditor(text: viewStore.binding(
                            get: { $0.text },
                            send: EditAppointmentAction.textChanged
                        ))
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(R.color.lightGray()), lineWidth: 0.5)
                        )
                        .introspectTextView(customize: { textView in
                            textView.becomeFirstResponder()
                        })

                        HStack {
                            Spacer()

                            Text("\(viewStore.state.text.count)/200")
                                .font(.system(size: 12))
                                .foregroundColor(Color(R.color.lightGray()))
                        }

                        Button(action: {
                            viewStore.send(.updateAppointment)
                        }, label: {
                            ImageWithTextHStack(uiImage: R.image.commonEdit(),
                                                text: R.string.localizable.myAppointmentsEditText().uppercased())
                        })
                        .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.acapulco()))
                        .padding(.horizontal, 20)

                        Button(action: {
                            viewStore.send(.deleteAppointment(appointment: viewStore.state.appointment))
                        }, label: {
                            ImageWithTextHStack(uiImage: R.image.medrecordCancel(),
                                                text: R.string.localizable.myAppointmentsCancelAppointment().uppercased())
                        })
                        .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.burntSienna()))
                        .padding(.top, 10)
                        .padding(.horizontal, 20)

                        Spacer()
                    }.padding()
                }
            }
        }
    }
}
