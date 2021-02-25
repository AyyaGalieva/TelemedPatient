//
//  FeedBackView.swift
//  TelemedPatient
//
//  Created by Galieva on 11.01.2021.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct FeedBackView: View {

    struct ViewState: Equatable {
        var id: Int
        var ownerId: String
        var comment: String
        var isSendFeedbackButtonDisabled: Bool
    }

    enum ViewAction {
        case commentChanged(_ comment: String)
        case sendButtonTapped
        case validate
    }

    let store: Store<FeedBackState, FeedBackAction>

    init(store: Store<FeedBackState, FeedBackAction>) {
        self.store = store
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        GeometryReader { geometry in
        WithViewStore(store.scope(state: { $0.view }, action: FeedBackAction.view)) { viewStore in
            VStack(alignment: .center) {
                Text(R.string.localizable.profileFeedBack())
                    .foregroundColor(Color(R.color.blackLabel()))
                    .font(.system(size: 20))
                    .fontWeight(.thin)
                
                ZStack(alignment: .topLeading) {
                    let text = viewStore.binding(
                        get: { $0.comment },
                        send: ViewAction.commentChanged)
                    if viewStore.comment.isEmpty {
                        Text(R.string.localizable.feedbackComment())
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                    }
                    TextEditor(text: text)
                        .padding(4)
                        .onChange(of: viewStore.comment) { _ in
                            viewStore.send(.validate)
                                        }
                }
                .frame(width: geometry.size.width * 0.9, alignment: .center)
                .font(.body)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(R.color.lightGray()), lineWidth: 0.5))
                
                HStack() {
                    Spacer()

                    Text(String(viewStore.comment.count))
                                        .font(.system(size: 10))
                                        .padding(.trailing, 16)
                }


                Button(R.string.localizable.feedbackSend()) {
                    viewStore.send(.sendButtonTapped)
                }.buttonStyle(TelemedButtonStyle())
                .disabled(viewStore.isSendFeedbackButtonDisabled)
                .padding(.top, 20)
            }
            .alert(self.store.scope(state: { $0.alert }), dismiss: .alertDismissed)
        }
    }
    }
}
