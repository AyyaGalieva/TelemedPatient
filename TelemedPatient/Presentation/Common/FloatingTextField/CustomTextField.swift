//
//  CustomTextField.swift
//  TelemedPatient
//
//  Created by d.yurchenko on 30.11.2020.
//

import SwiftUI
import InputMask

// MARK: - CustomTextFieldContainerView

protocol CustomTextFieldContainerViewDelegate: class {
    
    func editingChanged(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

// создал контейнер, т.к. просто UITextField ломает верстку
final class CustomTextFieldContainerView: UIView {
    
    weak var delegate: CustomTextFieldContainerViewDelegate?
    
    // MARK: - Properties
    
    let textField = UITextField(frame: .zero)
    
    // MARK: - Init
    
    init(inputType: FloatingTextFieldInputType) {
        super.init(frame: .zero)
        addTextField(inputType: inputType)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addTextField(inputType: FloatingTextFieldInputType) {
        guard textField.superview == nil else { return }
        if inputType == .date {
            textField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        }
        textField.delegate = self
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        textField.isUserInteractionEnabled = inputType != .image
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        let newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-0@900-[textField]-0@900-|",
                                                            metrics: nil,
                                                            views: ["textField": textField])
        addConstraints(newConstraints)
    }
    
    @objc private func tapDone() {
        if let datePicker = textField.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = String.longDateFormat
            textField.text = dateformatter.string(from: datePicker.date)
            delegate?.editingChanged(textField)
        }
        textField.resignFirstResponder()
    }
    
    @objc private  func editingChanged(_ textField: UITextField) {
        delegate?.editingChanged(textField)
    }
}

extension CustomTextFieldContainerView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(textField) ?? true
    }
}

// MARK: - MaskType

enum MaskType {
    case phone
    
    var mask: Mask {
        switch self {
        case .phone:
            guard let mask = try? Mask(format: "+7 ([000]) [000]-[00]-[00]") else { fatalError() }
            return mask
        }
    }
    
    var minValidLength: Int? {
        switch self {
        case .phone:
            return 11
        }
    }
}

// MARK: - CustomTextField

struct CustomTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, CustomTextFieldContainerViewDelegate {
        
        // MARK: - Init
        
        internal init(text: Binding<String>,
                      maskType: MaskType? = nil,
                      onEditingChanged: ((Bool) -> Void)? = nil,
                      onCommit: (() -> Void)? = nil) {
            self._text = text
            self.maskType = maskType
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        //MARK: - Binding Properties
        
        @Binding private var text: String
        
        //MARK: - Properties
        
        private let maskType: MaskType?
        
        private let onEditingChanged: ((Bool) -> Void)?

        private let onCommit: (() -> Void)?
        
        // MARK: - Private
        
        private func applyMask(toString string: String, autocomplete: Bool) -> String {
            guard let maskType = maskType else { return string }
            let result: Mask.Result = maskType.mask.apply(toText: CaretString(string: string,
                                                                              caretPosition: string.endIndex,
                                                                              caretGravity: .forward(autocomplete: autocomplete)))
            return result.formattedText.string
        }
        
        // MARK: - CustomTextFieldContainerViewDelegate
        
        func editingChanged(_ textField: UITextField) {
            guard let text = textField.text else { return }
            let textAfterMask = applyMask(toString: text, autocomplete: false)
            self.text = textAfterMask
            guard maskType != nil else { return }
            textField.text = textAfterMask
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.onEditingChanged?(false)
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.onEditingChanged?(true)
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onCommit?()
            textField.endEditing(true)
            return true
        }
    }
    
    // MARK: - Init
    
    internal init(_ text: Binding<String>,
                  maskType: MaskType? = nil,
                  isSecureEntry: Binding<Bool>? = nil,
                  shouldBecomeFirstResponder: Bool = false,
                  onEditingChanged: ((Bool) -> Void)? = nil,
                  onCommit: (() -> Void)? = nil) {
        self._text = text
        self.maskType = maskType
        self._isSecureEntry = isSecureEntry ?? Binding.constant(false)
        self.shouldBecomeFirstResponder = shouldBecomeFirstResponder
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
    
    //MARK: - Binding Properties
    
    @Binding private var text: String
    
    @Binding private var isSecureEntry: Bool
    
    // MARK: - Environment
    
    @Environment(\.keyboardType) var keyboardType
    
    @Environment(\.autocapitalization) var autocapitalization
    
    @Environment(\.textContentType) var textContentType
    
    @Environment(\.floatingTextFieldInputType) var inputType
    
    //MARK: - Properties
    
    private var shouldBecomeFirstResponder: Bool
    
    private var maskType: MaskType?
    
    private let onEditingChanged: ((Bool) -> Void)?
    
    private let onCommit: (() -> Void)?
    
    // MARK: - Internal
    
    internal func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> CustomTextFieldContainerView {
        let view = CustomTextFieldContainerView(inputType: inputType)
        view.delegate = context.coordinator
        view.textField.autocapitalizationType = autocapitalization
        view.textField.keyboardType = keyboardType
        view.textField.textContentType = textContentType
        return view
    }

    internal func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, maskType: maskType, onEditingChanged: onEditingChanged, onCommit: onCommit)
    }

    internal func updateUIView(_ uiView: CustomTextFieldContainerView, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.textField.text = text
        uiView.textField.isSecureTextEntry = isSecureEntry
        if shouldBecomeFirstResponder && !uiView.textField.isFirstResponder {
            uiView.firstResponder?.resignFirstResponder()
            uiView.textField.becomeFirstResponder()
        }
    }
}
