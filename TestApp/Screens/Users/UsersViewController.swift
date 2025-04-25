import UIKit
import Combine

class UsersViewController: ViewController<UsersViewModel> {
    
    private var emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .noUser))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let noUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(size: 20)
        label.textColor = UIColor(resource: .text)
        label.text = "There are no users yet"
        return label
    }()
    
    private lazy var emptyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyImageView, noUserLabel])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0, left: 82, bottom: 0, right: 16)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UsersCell.self, forCellReuseIdentifier: UsersCell.identifierCell)
        return tableView
    }()
    
    private var loadingFooterContainer: UIView = {
        let container = UIView()
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        container.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(container)
            make.verticalEdges.equalToSuperview().inset(24)
        }
        
        return container
    }()
    
    private var activityIndicator: UIActivityIndicatorView {
        return loadingFooterContainer.subviews.first { $0 is UIActivityIndicatorView } as! UIActivityIndicatorView
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var loadMoreUsersSubject: PassthroughSubject<Void, Never> = .init()
    
    override func setupView() {
        super.setupView()
        view.addSubview(emptyStackView)
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        emptyStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func setupOutput() {
        super.setupOutput()
        let input = UsersViewModel.Input(
            loadMoreUsersPublisher: loadMoreUsersSubject.eraseToAnyPublisher()
        )
        
        viewModel.transform(input, outputHandler: self.setupInput(input:))
    }
    
    override func setupInput(input: UsersViewModel.Output) {
        super.setupInput(input: input)
        setupReloadData(input)
    }
    
    private func setupReloadData(_ input: UsersViewModel.Output) {
        input.reloadPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.tableView.reloadData()
                self.emptyStackView.isHidden = !self.viewModel.users.isEmpty
            }
            .store(in: &cancellables)
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersCell.identifierCell, for: indexPath) as? UsersCell else {
            return UITableViewCell()
        }
        cell.configure(viewModel.users[indexPath.row])
        
        cell.separatorInset = indexPath.row == viewModel.users.count - 1 ?
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) :
        tableView.separatorInset
        
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 50 && viewModel.currentPage <= viewModel.totalPages {
            loadMoreUsersSubject.send()
            
            if !activityIndicator.isAnimating {
                tableView.tableFooterView = loadingFooterContainer
                activityIndicator.startAnimating()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !viewModel.isLoading {
            activityIndicator.stopAnimating()
            tableView.tableFooterView = nil
        }
    }
}
