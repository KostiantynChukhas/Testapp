import Combine
import UIKit

class UsersViewModel {
    
    private let coordinator: UsersCoordinator
    private var cancellables = Set<AnyCancellable>()
    private var userService: UserServiceType = ServiceHolder.shared.get(by: UserService.self)
    private var reloadSubject: PassthroughSubject<Void, Never> = .init()
    private(set) var currentPage: Int = 1
    private(set) var totalPages: Int = 1
    private(set) var isLoading: Bool = false
    private(set) var users: [User] = []
    
    
    init(_ coordinator: UsersCoordinator) {
        self.coordinator = coordinator
        getUsers(page: currentPage)
    }
    
    private func getUsers(page: Int) {
        guard !isLoading else { return }
        
        isLoading = true
        Task { @MainActor [weak self] in
            
            let response = try? await self?.userService.getUsers(page: page, count: 10)
            if let usersResponse = response {
                self?.users.append(contentsOf: usersResponse.users ?? [])
                self?.currentPage += 1
                self?.totalPages = usersResponse.totalPages ?? 0
                self?.reloadSubject.send()
            }
            
            self?.isLoading = false
        }
    }
}

extension UsersViewModel: ViewModelProtocol {
    
    struct Input {
        let loadMoreUsersPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let reloadPublisher: AnyPublisher<Void, Never>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        setupLoadMoreUsers(input)
        let output = Output(
            reloadPublisher: reloadSubject.eraseToAnyPublisher()
        )
        
        outputHandler(output)
    }
    
    private func setupLoadMoreUsers(_ input: Input) {
        input.loadMoreUsersPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                guard currentPage <= totalPages else { return }
                getUsers(page: currentPage)
            }
            .store(in: &cancellables)
    }
}
