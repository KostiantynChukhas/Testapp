import Foundation

extension String {
    func digitsOnly() -> String {
          return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
      }
}
