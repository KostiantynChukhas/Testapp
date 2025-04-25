import UIKit
import SnapKit

class BaseView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        configureView()
        makeConstraints()
        
        backgroundColor = .clear
    }
    
    func configureView() { }
    func makeConstraints() { }
}
