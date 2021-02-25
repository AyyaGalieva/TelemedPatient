//
// Created by Андрей Кривобок on 15.01.2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Introspect

extension View {
    public func introspectTextView(customize: @escaping (UITextView) -> ()) -> some View {
        inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: UITextView.self, from: viewHost)
            },
            customize: customize
        ))
    }
}

struct CreateAppointmentView: View {
    
    struct ViewState {
    }
    
    enum ViewAction {
        case textChanged
    }
    
    let store: Store<CreateAppointmentState, CreateAppointmentAction>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(store) { viewStore in
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

                    Text(R.string.localizable.appointmentsCreateAppointment(viewStore.timeSlot.beginTimeString, viewStore.timeSlot.endTimeString))
                        .padding()
                    AppointmentTextView(text: viewStore.binding(
                        get: { $0.text },
                        send: CreateAppointmentAction.textChanged
                    ))
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(R.color.lightGray()), lineWidth: 0.5)
                    )
                    .introspectTextView(customize: { textView in
                        textView.becomeFirstResponder()
                    })
                    
                    Button(action: {
                        viewStore.send(.createAppointment)
                    }, label: {
                        Text(R.string.localizable.mainSignUpTab().uppercased())
                    })
                    .buttonStyle(TelemedButtonStyle(backgroundColor: R.color.acapulco()))
                    .padding(20)
                    
                    Spacer()
                }.padding()
            }
        }
    }
}

struct AppointmentTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textView.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: R.string.localizable.mainSignUpTab(), style: .done, target: self, action: #selector(textView.createAppointmentButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textView.inputAccessoryView = toolBar
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

extension  UITextView {
    @objc func createAppointmentButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }
}
