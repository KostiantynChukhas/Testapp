import UIKit
import Combine

class SignUpViewController: ViewController<SignUpViewModel> {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.register(SignUpTextCell.self, forCellReuseIdentifier: SignUpTextCell.identifierCell)
        tableView.register(SignUpRadioCell.self, forCellReuseIdentifier: SignUpRadioCell.identifierCell)
        tableView.register(SignUpButtonCell.self, forCellReuseIdentifier: SignUpButtonCell.identifierCell)
        tableView.register(SignUpUploadPhotoCell.self, forCellReuseIdentifier: SignUpUploadPhotoCell.identifierCell)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var tapSignUpSubject: PassthroughSubject<Void, Never> = .init()
    private let imagePicker: ImagePicker = ImagePicker()
    
    override func setupView() {
        super.setupView()
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func setupOutput() {
        super.setupOutput()
        let input = SignUpViewModel.Input(
            signUpPublisher: tapSignUpSubject.eraseToAnyPublisher()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: SignUpViewModel.Output) {
        super.setupInput(input: input)
        setupAnswers(input)
        setupReload(input)
    }
    
    private func setupReload(_ input: SignUpViewModel.Output) {
        input.onReloadPublisher
            .sink { [weak self]  _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupAnswers(_ input: SignUpViewModel.Output) {
        input.answerPublisher
            .sink { type in
                AlertHelper.showAlert(type)
            }
            .store(in: &cancellables)
    }
}

extension SignUpViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .text(let types):
            return types.count
        case .radio, .button, .uploadPhoto:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sections[indexPath.section] {
            
        case .text(let type):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SignUpTextCell.identifierCell, for: indexPath) as? SignUpTextCell else {
                return UITableViewCell()
            }
            cell.configure(type[indexPath.row])
            cell.bind(to: viewModel.signUpSectionsModel)
            return cell
        case .radio(let value, let header):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SignUpRadioCell.identifierCell, for: indexPath) as? SignUpRadioCell else {
                return UITableViewCell()
            }
            cell.configure(value, header: header)
            cell.bind(to:  viewModel.signUpSectionsModel)
            cell.selectedIndex = { [weak self] index in
                self?.viewModel.signUpSectionsModel.radioValue = index
            }
            return cell
        case .uploadPhoto:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SignUpUploadPhotoCell.identifierCell, for: indexPath) as? SignUpUploadPhotoCell else {
                return UITableViewCell()
            }
            cell.uploadCompletion = { [weak self] in
                guard let self else { return }
                self.imagePicker.presentActionSheet(from: self) { [weak self] imageData in
                    self?.viewModel.signUpSectionsModel.imageValue = imageData.first
                    self?.viewModel.signUpSectionsModel.imageDataError = imageData.first == nil
                }
            }
            cell.bind(to: viewModel.signUpSectionsModel)
            return cell
        case .button:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SignUpButtonCell.identifierCell, for: indexPath) as? SignUpButtonCell else {
                return UITableViewCell()
            }
            cell.bind(to: viewModel.signUpSectionsModel)
            cell.onTapSignUp = { [weak self] in
                self?.tapSignUpSubject.send()
            }
            return cell
        }
    }
}
