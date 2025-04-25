import UIKit

enum FieldType {
    case email
    case phone
    case name

    var placeholder: String {
        switch self {
        case .email: return "Email"
        case .phone: return "Phone"
        case .name: return "Your name"
        }
    }
    
    var error: String {
        switch self {
        case .email: return "Invalid email format"
        case .phone: return "Required field"
        case .name: return "Required field"
        }
    }

    var textContentType: UITextContentType {
        switch self {
        case .email: return .emailAddress
        case .phone: return .telephoneNumber
        case .name: return .name
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .email: return .emailAddress
        case .phone: return .phonePad
        case .name: return .default
        }
    }
}

final class TextFieldView: BaseView {

    // MARK: - Subviews

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .init(size: 16)
        textField.textColor = UIColor(resource: .text)
        textField.tintColor = UIColor(resource: .text)
        textField.addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()

    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .disabled)
        label.font = .init(size: 16)
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(resource: .error)
        return label
    }()

    var fieldLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(resource: .border).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    var textChanged: SimpleClosure<String> = { _ in }

    // MARK: - Public Properties

    var hintMessage: String? {
        didSet { updateErrorLabel() }
    }

    var alwaysShowHintInErrorLabel: Bool = false {
        didSet { updateErrorLabel() }
    }

    var returnKey: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    var text: String {
        get { return textField.text ?? "" }
        set { setText(newValue) }
    }

    var isValid: Bool = true {
        didSet {
            updateErrorLabel()
            UIView.animate(withDuration: 0.3) {
                self.fieldLayerView.layer.borderColor = self.isValid ? UIColor(resource: .border).cgColor : UIColor(resource: .error).cgColor
            }
            layoutSubviews()
        }
    }

    @Published var _text: String = ""
    var shouldOverrideBackgroundColor: Bool = false

    // MARK: - Private Properties

    private var isPasswordTextField: Bool = false
    private var errorMessage: String = ""
    private var type: FieldType?

    private var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }

    private var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    private var textContentType: UITextContentType {
        get { textField.textContentType }
        set { textField.textContentType = newValue }
    }

    // MARK: - Init & Layout

    override func configureView() {
        super.configureView()
        addSubview(fieldLayerView)
        addSubview(errorLabel)
        addSubview(placeholderLabel)
        fieldLayerView.addSubview(textField)
    }

    override func makeConstraints() {
        super.makeConstraints()

        fieldLayerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(56)
        }

        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(textField.snp.horizontalEdges)
            make.centerY.equalTo(textField.snp.centerY)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(fieldLayerView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(20)
        }
    }

    // MARK: - Public Methods

    func setType(type: FieldType) {
        self.type = type
        placeholderLabel.text = type.placeholder
        textContentType = type.textContentType
        keyboardType = type.keyboardType
        errorMessage = type.error
    }

    func setText(_ text: String?) {
        textField.text = text
        updateTitle(isActive: true)
    }

    func hideError() {
        isValid = true
    }
    
    func setError(_ isError: Bool) {
        self.isValid = !isError
    }

    func checkValidateField() {
        guard let type, !text.isEmpty else { return }
        switch type {
        case .email:
            isValid = Validator.validateEmail(enteredEmail: text)
        case .phone:
            isValid = Validator.validatePhoneNumber(phone: text)
        case .name:
            isValid = Validator.validateName(name: text)
        }
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else {
            return true
        }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if type == .phone {
            return updatedText.count <= 23
        }

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTitle(isActive: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateTitle(isActive: textField.hasText)
    }
}

private extension TextFieldView {
    func updateErrorLabel() {
        if alwaysShowHintInErrorLabel {
            if isValid {
                errorLabel.text = hintMessage ?? type?.placeholder ?? ""
                errorLabel.textColor = UIColor(resource: .disabled)
            } else {
                errorLabel.text = errorMessage
                errorLabel.textColor = UIColor(resource: .error)
            }
        } else {
            errorLabel.text = isValid ? "" : errorMessage
        }
    }

    func updateTitle(isActive: Bool) {
        let activeFont = UIFont.init(size: 12, type: .regular) ?? .systemFont(ofSize: 12)
        let standardFont = UIFont.init(size: 16, type: .regular) ?? .systemFont(ofSize: 16)

        let targetFont = isActive ? activeFont : standardFont
        let targetTransform = isActive ? CGAffineTransform(translationX: 0, y: -14) : .identity

        UIView.transition(with: placeholderLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.placeholderLabel.font = targetFont
            self.placeholderLabel.transform = targetTransform
            self.textField.transform = isActive ? CGAffineTransform(translationX: 0, y: 4) : .identity
        })
    }

    @objc func textFieldTextDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if type == .phone {
                textField.text = format(phone: text)
            }
        }
        
        textChanged(text)
    }
    
    func format(with mask: String = "+XX (XXX) XXX - XX - XX", phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

