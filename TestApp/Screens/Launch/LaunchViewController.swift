import UIKit
import Combine
import SnapKit

class LaunchViewController: ViewController<LaunchViewModel> {
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .launch))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 50, type: .regular)
        label.textColor = .black.withAlphaComponent(0.87)
        label.textAlignment = .center
        label.text = "testtask".uppercased()
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, nameLabel])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = UIColor(resource: .primary)
        view.addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualTo(10)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(95)
            make.height.equalTo(65)
        }
    }
}
