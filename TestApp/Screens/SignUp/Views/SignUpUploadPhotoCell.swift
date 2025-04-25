import UIKit

class SignUpUploadPhotoCell: BaseTableViewCell {
    
    private var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(resource: .border).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(size: 16)
        label.textColor = UIColor(resource: .disabled)
        label.text = "Upload your photo"
        return label
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(UIColor(resource: .secondaryDark), for: .normal)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .init(size: 12)
        label.textColor = UIColor(resource: .error)
        return label
    }()
    
    var uploadCompletion: EmptyClosureType = { }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(errorLabel)
        contentView.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(uploadButton)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        baseView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(65)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(baseView.snp.horizontalEdges).inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(uploadButton.snp.trailing)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(90)
        }
    }
    
    func bind(to model: SignUpSectionsModel) {
        model.$imageDataError
            .sink { [weak self] isError in
                self?.errorLabel.isHidden = !isError
                self?.errorLabel.text = isError ? "Photo is required" : nil
                self?.titleLabel.text = isError ? "Upload photo" : model.imageValue?.1 == nil ? "Upload photo" : model.imageValue?.1
                self?.titleLabel.textColor = isError ? UIColor(resource: .error) : UIColor(resource: .disabled)
                self?.baseView.layer.borderColor = isError ? UIColor(resource: .error).cgColor :  UIColor(resource: .border).cgColor
            }
            .store(in: &cancellables)
    }
    
    @objc private func uploadButtonTapped() {
        uploadCompletion()
    }
}
