import UIKit

class RadioCell: BaseTableViewCell {

    var radioView: UIImageView = {
        let radioButton = UIImageView()
        radioButton.contentMode = .scaleAspectFit
        return radioButton
    }()

    private let ttlLabel: UILabel = {
        let label = UILabel()
        label.font = .init(size: 16)
        label.textColor = UIColor(resource: .text)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [radioView, ttlLabel])
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(contentStackView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        contentStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(33)
            make.trailing.equalToSuperview().offset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        radioView.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
    
        selectionStyle = .none
    }
    
    func configure(with model: SignUpRadioModel) {
        radioView.image = model.isSelected ? UIImage(resource: .radioSelect) :  UIImage(resource: .radioDeselect)
        ttlLabel.text = model.value
    }
}
