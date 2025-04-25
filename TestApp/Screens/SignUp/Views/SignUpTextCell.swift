import UIKit

class SignUpTextCell: BaseTableViewCell {
    
    private var textFieldView: TextFieldView = {
        let view = TextFieldView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var type: FieldType = .name
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(textFieldView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        textFieldView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(12)
        }
    }
    
    func configure(_ type: FieldType) {
        self.type = type
        textFieldView.setType(type: type)
        textFieldView.hintMessage = type == .phone ? Defines.phonePatern : ""
        textFieldView.alwaysShowHintInErrorLabel = type == .phone
    }
    
    func bind(to model: SignUpSectionsModel) {
        textFieldView.textChanged = { [weak self] text in
            guard let self else { return }
            switch self.type {
            case .email:
                model.updateEmailValue(newValue: text)
            case .name:
                model.updateNameValue(newValue: text)
            case .phone:
                model.updatePhoneValue(newValue: text)
            }
        }
        
        model.$emailIsError
            .sink { [weak self] isError in
                if self?.type == .email {
                    self?.textFieldView.setError(isError)
                }
            }.store(in: &cancellables)
        
        model.$nameIsError
            .sink { [weak self] isError in
                if self?.type == .name {
                    self?.textFieldView.setError(isError)
                }
            }.store(in: &cancellables)
        
        model.$phoneIsError
            .sink { [weak self] isError in
                if self?.type == .phone {
                    self?.textFieldView.setError(isError)
                }
            }.store(in: &cancellables)
    }
    
}
