import UIKit

class TabBarButton: UIView {
    enum State {
        case selected
        case deselected
    }
    
    private var tabImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 16, type: .semiBold)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tabImageView, titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        return button
    }()
    
    var isSelected: Bool = false {
        didSet {
            layoutIfNeeded()
        }
    }
    var onClick: (TabBarButton) -> Void = { _ in }
    
    var item: TabBarItem = TabBarItem(title: "", image:  UIImage(), selectableImage: UIImage()) {
        didSet {
            self.titleLabel.text = item.title
            self.tabImageView.image = item.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        addSubview(contentStackView)
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func handleTapButton() {
        onClick(self)
    }
    
    func setState(_ state: State, index: Int) {
        self.tabImageView.tintColor = state == .selected ? UIColor(resource: .blue) : UIColor(resource: .subtext)
        self.titleLabel.textColor = state == .selected ? UIColor(resource: .blue) :  UIColor(resource: .subtext)
    }
}


