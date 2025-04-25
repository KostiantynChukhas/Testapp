import UIKit

extension UIFont {
    enum FontType: String {
        case regular = "Regular"
        case semiBold = "SemiBold"
    }
    
    convenience init?(size: CGFloat, type: FontType = .regular) {
        self.init(name:"NunitoSans-\(type.rawValue.capitalized)", size: size)
    }
}

