//
//  FloatingTextField.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 26.11.2020.
//

import SwiftUI

struct FloatingTextField: View {
    
    private struct Constants {
        static let textFieldHeight: CGFloat = 22
        static let imagesEdge: CGFloat = 24
        static let placeholderSmallFontSize: CGFloat = 14
        static let placeholderBigFontSize: CGFloat = 17
        static let errorFontSize: CGFloat = 12
        static let defaultPaddingInset: CGFloat = 15
        static let smallPaddingInset: CGFloat = 8
        static let leftImagePadding: CGFloat = 7
        static let animationDuration: Double = 0.15
        static let placeholderBottomInset: CGFloat = 45
    }
    
    //MARK: Binding Properties
    
    @Binding private var text: String
    
    @Binding private var errorText: String?
    
    //MARK: State Properties
    
    @State private var isEditing: Bool = false
    
    @State private var shouldBecomeFirstResponder: Bool = false
    
    @State private var totalHeight: CGFloat = 66 // default value just for static Preview
    
    @State private var placeholderFontSize: CGFloat = 17
    
    @State private var isSecureInputOn: Bool = true
    
    @State private var isShowingImagePicker = false
    
    @State private var inputImage: NamedUIImage?
    
    //MARK: Observed Object
    
    @ObservedObject private var notifier = FloatingTextFieldNotifier()
    
    //MARK: Properties
    
    private var placeholderText: String
        
    private var onEditingChanged: ((Bool) -> Void)?
    
    private var onCommit: (() -> Void)?
    
    private var onImagePickerDismiss: ((NamedUIImage) -> Void)?
    
    private var isValid: Bool

    // MARK: - Private
    
    private var placeholderBottomInset: CGFloat {
        textVerticalInset * 1.5 + Constants.textFieldHeight + Constants.placeholderSmallFontSize * 0.5
    }
    
    private var zStackHeight: CGFloat {
        Constants.textFieldHeight + Constants.placeholderSmallFontSize + textVerticalInset * 2
    }
    
    private var textVerticalInset: CGFloat {
        notifier.borderType == .roundedRectangle ? Constants.defaultPaddingInset : Constants.smallPaddingInset
    }
    
    private var textHorizontalInset: CGFloat {
        notifier.borderType == .roundedRectangle ? Constants.defaultPaddingInset : 0
    }
    
    private var placeholderLeadingInset: CGFloat {
        notifier.borderType == .roundedRectangle ? Constants.defaultPaddingInset :
            hasImage ? Constants.leftImagePadding + Constants.imagesEdge : 0
    }
    
    private var placeholderIsTitle: Bool {
        isEditing || text.count != 0
    }
    
    private var placeholderFontSizeValue: CGFloat {
        guard placeholderIsTitle else {
            return Constants.placeholderBigFontSize
        }
        return Constants.placeholderSmallFontSize
    }
    
    private var stateColor: Color {
        return isEditing ? Color(R.color.cornflowerBlue()) :
            ((isValid || text.isEmpty) ? .gray : Color(R.color.burntSienna()))
    }
    
    private func getTextFieldWidth(withGeometry geometry: GeometryProxy) -> CGFloat {
        var width = geometry.size.width - textHorizontalInset * 2
        if notifier.isSecureTextField {
            width -= Constants.defaultPaddingInset + Constants.imagesEdge
        }
        if hasImage {
            width -= Constants.leftImagePadding + Constants.imagesEdge
        }
        return width
    }
    
    private var bottomLineHeight: CGFloat {
        return isEditing ? 2 : 1
    }
    
    private var hasImage: Bool {
        return notifier.borderType == .bottomLine && notifier.leftImage != nil
    }
    
    //MARK: Init
    
    public init(_ placeholder: String,
                text: Binding<String>? = nil,
                errorText: Binding<String?> = .constant(nil),
                isValid: Bool = true,
                onEditingChanged: ((Bool) -> Void)? = nil,
                onCommit: (() -> Void)? = nil,
                onImagePickerDismiss: ((NamedUIImage) -> Void)? = nil) {
        // TODO временное решение
        self._text = text ?? .constant("")
        self.placeholderText = placeholder
        self._errorText = errorText
        self.isValid = isValid
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.onImagePickerDismiss = onImagePickerDismiss
    }
    
    //MARK: Views
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .leading) {
                        HStack(spacing: Constants.leftImagePadding) {
                            if hasImage, let image = notifier.leftImage {
                                image
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(stateColor)
                                .frame(width: Constants.imagesEdge,
                                       height: Constants.imagesEdge)
                            }
                            
                            CustomTextField($text,
                                            maskType: notifier.maskType,
                                            isSecureEntry: notifier.isSecureTextField ? $isSecureInputOn : nil,
                                            shouldBecomeFirstResponder: shouldBecomeFirstResponder,
                                            onEditingChanged: { isEditing in
                                                if !isEditing {
                                                    shouldBecomeFirstResponder = false
                                                }
                                                self.isEditing = isEditing
                                                onEditingChanged?(isEditing)
                                            }, onCommit: {
                                                shouldBecomeFirstResponder = false
                                                onCommit?()
                            })
                            .frame(width: getTextFieldWidth(withGeometry: geometry),
                                   height: Constants.textFieldHeight)
                                // TODO можно будет также заменить это на notifier для customtextfield
                            .environment(\.autocapitalization, notifier.autocapitalization)
                            .environment(\.keyboardType, notifier.keyboardType)
                            .environment(\.textContentType, notifier.textContentType)
                            .environment(\.floatingTextFieldInputType, notifier.inputType)
                            .foregroundColor(Color(R.color.blackLabel()))
                            .accentColor(Color(R.color.blackLabel()))
                            .background(Color.white)
                            .animation(.linear(duration: Constants.animationDuration))
                            
                            if notifier.isSecureTextField {
                                Button(action: {
                                    isSecureInputOn.toggle()
                                }, label: {
                                    Image(isSecureInputOn ? R.image.commonClosedEye() : R.image.commonOpenEye())
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(stateColor)
                                        .frame(width: Constants.imagesEdge,
                                               height: Constants.imagesEdge)
                                })
                            }
                        }.padding(EdgeInsets(top: textVerticalInset,
                                             leading: textHorizontalInset,
                                             bottom: textVerticalInset,
                                             trailing: textHorizontalInset))
                        .frame(width: geometry.size.width)
                        .overlay(RoundedRectangle(cornerRadius: 4)
                                    .stroke(notifier.borderType == .roundedRectangle ? stateColor : Color.clear,
                                            lineWidth: 1)
                        )
                        
                        if !placeholderText.isEmpty {
                            Text(placeholderText)
                            .lineLimit(1)
                            .animatableSystemFont(size: placeholderFontSize)
                            .frame(maxWidth: geometry.size.width - Constants.defaultPaddingInset * 2,
                                   maxHeight: placeholderFontSize).fixedSize()
                            .foregroundColor(stateColor)
                            .background(Color.white)
                            .padding(EdgeInsets(top: 0,
                                                leading: placeholderLeadingInset,
                                                bottom: placeholderIsTitle ? placeholderBottomInset : 0,
                                                trailing: 0)
                            )
                            .animation(.linear(duration: Constants.animationDuration))
                            .onTapGesture {
                                switch notifier.inputType {
                                case .image:
                                    isShowingImagePicker = true
                                default:
                                    guard !isEditing else { return }
                                    shouldBecomeFirstResponder = true
                                }
                            }
                            // модификатор "allowsHitTesting" почему-то не работает https://stackoverflow.com/questions/63368846/text-in-front-of-textfield-blocking-editing-in-swiftui, пока добавил "onTapGesture"
//                            .allowsHitTesting(false)
                        }
                        
                        if notifier.borderType == .bottomLine {
                            Divider()
                            .frame(height: bottomLineHeight, alignment: .bottomLeading)
                            .background(stateColor)
                            .padding(.top, zStackHeight - Constants.placeholderSmallFontSize + 1)
                        }
                    }.frame(height: zStackHeight)
                    
                    if !isValid,
                       let errorText = errorText,
                       !errorText.isEmpty,
                       !isEditing,
                       !text.isEmpty {
                        Text(errorText)
                            .font(.system(size: Constants.errorFontSize))
                            .lineLimit(nil)
                            .frame(maxWidth: geometry.size.width - Constants.defaultPaddingInset * 2,
                                   alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, Constants.defaultPaddingInset)
                            .foregroundColor(Color(R.color.burntSienna()))
                    }
                }
                .background(GeometryReader { gp -> Color in
                    DispatchQueue.main.async {
                        // update on next cycle with calculated height of ZStack !!!
                        self.placeholderFontSize = self.placeholderFontSizeValue
                        self.totalHeight = gp.size.height
                    }
                    return Color.clear
                })
                .animation(.linear(duration: Constants.animationDuration))
            }
        }.frame(height: totalHeight)
        .onTapGesture {
            guard notifier.inputType == .image else { return }
            isShowingImagePicker = true
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: {
            guard let inputImage = inputImage else { return }
            onImagePickerDismiss?(inputImage)
            self.inputImage = nil
        }) {
            ImagePicker(image: $inputImage)
        }
    }
}

// MARK: - Preview

struct demo: View {
    @State var name: String = "Тест"
    @State var email: String = ""
    var body: some View {
        VStack(spacing: 10) {
            FloatingTextField("Имя", text: $name)
                .borderType(.bottomLine)
                .leftImage(Image(R.image.medrecordPerson()))
            FloatingTextField("Пароль", text: $email)
                .isSecureTextField(true)
        }.padding()
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            demo()
        }
    }
}

// MARK: - FloatingTextField + FloatingTextFieldNotifier

extension FloatingTextField {
        
    public func isSecureTextField(_ isSecureTextField: Bool) -> Self {
        notifier.isSecureTextField = isSecureTextField
        return self
    }
    
    public func maskType(_ maskType: MaskType) -> Self {
        notifier.maskType = maskType
        return self
    }
    
    public func leftImage(_ leftImage: Image) -> Self {
        notifier.leftImage = leftImage
        return self
    }
    
    public func borderType(_ borderType: FloatingTextFieldBorderType) -> Self {
        notifier.borderType = borderType
        return self
    }
    
    public func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        notifier.keyboardType = keyboardType
        return self
    }
    
    public func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) -> Self {
        notifier.autocapitalization = autocapitalization
        return self
    }
    
    public func textContentType(_ textContentType: UITextContentType) -> Self {
        notifier.textContentType = textContentType
        return self
    }
    
    public func inputType(_ inputType: FloatingTextFieldInputType) -> Self {
        notifier.inputType = inputType
        return self
    }
}
