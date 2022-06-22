//
//  CustomTextFieldWithImage.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 17/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class CustomTextField: UIControl {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    let _color = UIColor.label
    
    var textfieldinputAccessoryView: UIView?{
        didSet{
            textfield.inputAccessoryView = textfieldinputAccessoryView
        }
    }
    
    var textFieldinputView: UIView?{
        didSet{
            textfield.inputView = textFieldinputView
        }
    }
    
    private var _leftImage: UIImage?
    private var _hintForField: String?
    
    private var _maxText: Int? = nil
    private var _isSecureText = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
         super.prepareForInterfaceBuilder()
         setupView()
         contentView?.prepareForInterfaceBuilder()
     }
    
    private func setupView() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfield.delegate = self
    }
     
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomTextField", bundle: bundle)
        return nib.instantiate(withOwner: self,
                               options: nil)
            .first as? UIView
    }
    
    func setupContent(placeholder: String, hint: String? = nil, isSecureText: Bool = false, contentType: UITextContentType? = nil, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .default, maxText: Int? = nil, isEnabled: Bool = true){
                
        textfield.placeholder = placeholder
        textfield.textContentType = contentType
        textfield.keyboardType = keyboardType
        textfield.isEnabled = isEnabled
        textfield.returnKeyType = returnKeyType
        textfield.isSecureTextEntry = isSecureText
        textfield.tintColor = _color
        
        _isSecureText = isSecureText
        _maxText = maxText
        _hintForField = hint
        
        notificationLabel.text = _hintForField

    }
    
    fileprivate func showNotification(validation: ValidationResult){
        if validation == .empty{
            notificationLabel.text = _hintForField
            notificationLabel.textColor = UIColor.opaqueSeparator
            separatorView.backgroundColor = UIColor.opaqueSeparator
        } else {
            notificationLabel.text = validation.message != nil ? validation.message : _hintForField
            notificationLabel.textColor = validation.isValid ? UIColor.opaqueSeparator : UIColor.red
            separatorView.backgroundColor = validation.isValid ? UIColor.opaqueSeparator : UIColor.red
        }
        
    }
    
    private func getMaxText(text: String, maxText: Int) -> String {
        if (text.count > maxText) {
            let index = text.index(text.startIndex, offsetBy: maxText)
            let textTemp = text[..<index]
            return String(textTemp)
        }
        
        return text
    }
    
    public func getText() -> String{
        return textfield.text == nil ? "" : textfield.text!
    }
    
    public func setText(content: String?){
        textfield.text = content
        sendActions(for: .valueChanged)
    }
    
    public override var isFirstResponder: Bool {
        return textfield.isFirstResponder
    }
    
    public override func becomeFirstResponder() -> Bool {
        return textfield.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        return textfield.resignFirstResponder()
    }
    
    // MARK: - Selector
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        separatorView.backgroundColor = !text.isEmpty ? _color : UIColor.lightGray
        if _maxText != nil {
            textField.text = getMaxText(text: text, maxText: _maxText ?? 0)
        }
        sendActions(for: .valueChanged)
    }
}

extension CustomTextField: UITextFieldDelegate{
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendActions(for: .editingDidEndOnExit)
        return true
    }
}

extension Reactive where Base: CustomTextField {
    var validationResult: Binder<ValidationResult> {
        return Binder(self.base) { view, result in
            view.showNotification(validation: result)
        }
    }
    
    var text: ControlProperty<String?> {
        return base.rx.controlProperty(
            editingEvents: [.valueChanged],
            getter: { field in
                return field.getText()
            }, setter: { field, value in
                field.setText(content: value)
        })
    }
}
