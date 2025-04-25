import UIKit

class SignUpButtonCell: BaseTableViewCell {
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .init(size: 18, type: .semiBold)
        button.backgroundColor = UIColor(resource: .primary)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(onTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    var onTapSignUp: EmptyClosureType = { }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(signUpButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        signUpButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(48)
            make.verticalEdges.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind(to model: SignUpSectionsModel) {
        model.$buttonIsEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFilled in
                self?.signUpButton.isEnabled = isFilled
                self?.signUpButton.backgroundColor = isFilled ? UIColor(resource: .primary) : UIColor(resource: .buttonDissabled)
                self?.signUpButton.setTitleColor(isFilled ? .black : UIColor(resource: .disabled), for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc private func onTapSignUpButton() {
        onTapSignUp()
    }
}
