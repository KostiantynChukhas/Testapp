import UIKit

enum AlertType {
    case success
    case error
    case internet
    
    var image: UIImage  {
        switch self {
        case .success:
            return UIImage(resource: .success)
        case .error:
            return UIImage(resource: .alreadyRegistered)
        case .internet:
            return UIImage(resource: .noInternet)
        }
    }
    
    var title: String {
        switch self {
        case .success:
            return "User successfully registered"
        case .error:
            return "That email is already registered"
        case .internet:
            return "There is no internet connection"
        }
    }
    
    var titleButton: String {
        switch self {
        case .success:
            return "Got it"
        case .internet, .error:
            return "Try again"
        }
    }
}

class AlertView: BaseView {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .init(size: 20)
        label.textColor = UIColor(resource: .text)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(send), for: .touchUpInside)
        button.backgroundColor = UIColor(resource: .primary)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(resource: .disabled)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, textLabel, sendButton])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    override func configureView() {
        super.configureView()
        self.backgroundColor = .white
        addSubview(contentStackView)
        addSubview(closeButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.size.equalTo(24)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(48)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(200)
        }
        
        textLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
    }
    
    @objc private func dismiss() {
        removeFromSuperview()
    }
    
    @objc private func send() {
        removeFromSuperview()
    }
    
    func configure(_ type: AlertType) {
        imageView.image = type.image
        sendButton.setTitle(type.titleButton, for: .normal)
        textLabel.text = type.title
        
        closeButton.isHidden = type == .internet
    }
}
