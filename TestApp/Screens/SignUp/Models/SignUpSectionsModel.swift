import Foundation
import Combine

class SignUpSectionsModel: ObservableObject {
    
    @Published var emailValue: String? {
        didSet { validateInputs() }
    }
    
    @Published var nameValue: String? {
        didSet { validateInputs() }
    }
    
    @Published var phoneValue: String? {
        didSet { validateInputs() }
    }
    
    @Published var radioValue: Int?
    @Published var imageValue: (Data, String?)?
    
    @Published private(set) var emailIsError: Bool = false
    @Published private(set) var nameIsError: Bool = false
    @Published private(set) var phoneIsError: Bool = false
    @Published private(set) var buttonIsEnabled: Bool = false
    @Published var imageDataError: Bool = false

    func updateEmailValue(newValue: String) {
        emailValue = newValue
    }

    func updateNameValue(newValue: String) {
        nameValue = newValue
    }

    func updatePhoneValue(newValue: String) {
        phoneValue = newValue.digitsOnly()
    }
    
    func updateRadioValue(newValue: Int) {
        radioValue = newValue
    }
    
    func validateInputs() {
        buttonIsEnabled = emailValue != nil || nameValue != nil || phoneValue != nil || imageValue?.0 != nil
    }

    func checkValidate() -> Bool {
        imageDataError = imageValue == nil
        emailIsError = !Validator.validateEmail(enteredEmail: emailValue ?? "")
        nameIsError = !Validator.validateName(name: nameValue ?? "")
        phoneIsError = !Validator.validatePhoneNumber(phone: phoneValue?.digitsOnly() ?? "")
        return !emailIsError && !nameIsError && !phoneIsError && imageValue?.0 != nil
    }
    
    func clearAll() {
        emailValue = nil
        nameValue = nil
        phoneValue = nil
        radioValue = nil
        imageValue = nil
        
        emailIsError = false
        nameIsError = false
        phoneIsError = false
        imageDataError = false
        buttonIsEnabled = false
    }

}
