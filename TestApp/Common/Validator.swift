import UIKit

struct Validator {
    static func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "^[\\w!#$%&'*+/=\\-?^_`{|}~ a-z A-Z]+(\\.[\\w!#$%&'*+/=\\-?^_`{|}~]+)*@[\\w-]+(\\.[\\w]+)*(\\.[a-z]{2,})$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    static func validatePhoneNumber(phone: String) -> Bool {
        let phoneFormat = "^((38))[0-9]{6,14}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneFormat)
        return phonePredicate.evaluate(with: phone)
    }
    
    static func validateName(name: String) -> Bool {
        let nameFormat = "^[\\p{L}]{3,}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameFormat)
        return namePredicate.evaluate(with: name)
    }

    
}
