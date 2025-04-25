import UIKit

protocol TabBarDelegate: AnyObject {
    func didSelectTab(index: Int)
}

class TabBar: UIView {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .tabBarBackground)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    var buttons: [TabBarButton] = []
    weak var delegate: TabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = self.bounds
        
        stackView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    func setupButtons(_ buttons: [TabBarButton]) {
        self.buttons = buttons
        
        for (index, button) in self.buttons.enumerated() {
            button.onClick = buttonAction(_:)
            button.setState(.deselected, index: index)
            stackView.addArrangedSubview(button)
        }
        
        self.buttons[0].setState(.selected, index: 0)
        self.layoutSubviews()
    }
    
    private func updateButtonStates(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            let state: TabBarButton.State = (index == selectedIndex) ? .selected : .deselected
            button.setState(state, index: index)
        }
    }

    func setSelect(by index: Int) {
        updateButtonStates(selectedIndex: index)
    }

    @objc func buttonAction(_ sender: TabBarButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        
        updateButtonStates(selectedIndex: index)
        delegate?.didSelectTab(index: index)
        self.stackView.layoutIfNeeded()
    }


}
