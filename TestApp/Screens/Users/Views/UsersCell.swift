import UIKit
import Kingfisher

class UsersCell: BaseTableViewCell {
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 18)
        label.textColor = UIColor(resource: .text)
        label.numberOfLines = 0
        return label
    }()
    
    private let workPositionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 14)
        label.textColor = UIColor(resource: .subtext)
        label.numberOfLines = 0
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 14)
        label.textColor = UIColor(resource: .text)
        label.numberOfLines = 0
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 14)
        label.textColor = UIColor(resource: .text)
        label.numberOfLines = 0
        return label
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(workPositionLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(phoneLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        workPositionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(nameLabel.snp.horizontalEdges)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(workPositionLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(workPositionLabel.snp.horizontalEdges)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(emailLabel.snp.horizontalEdges)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configure(_ model: User) {
        nameLabel.text = model.name
        workPositionLabel.text = model.position
        emailLabel.text = model.email
        phoneLabel.text = model.phone
        if let url = URL(string: model.photo ?? "") {
            avatarImageView.kf.setImage(with: url)
        }
    }
}
