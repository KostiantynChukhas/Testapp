import Combine
import UIKit

enum SignUpSections {
    case text([FieldType])
    case radio(value: [String], header: String)
    case uploadPhoto
    case button
}

class SignUpViewModel {
    
    private let coordinator: SignUpCoordinator
    private var userServie: UserServiceType = ServiceHolder.shared.get(by: UserService.self)
    private var cancellables = Set<AnyCancellable>()
    private var onReloadSubject: PassthroughSubject<Void, Never> = .init()
    private var answerSubject: PassthroughSubject<AlertType, Never> = .init()
    private(set) var sections: [SignUpSections] = []
    private(set) var signUpSectionsModel: SignUpSectionsModel = SignUpSectionsModel()
    
    init(_ coordinator: SignUpCoordinator) {
        self.coordinator = coordinator
        
        sections = [
            .text([.name, .email, .phone]),
            .radio(value: ["Frontend developer", "Backend developer", "Designer", "QA"], header: "Select your position"),
            .uploadPhoto,
            .button
        ]
    }
}

extension SignUpViewModel: ViewModelProtocol {
    
    struct Input {
        let signUpPublisher: AnyPublisher<Void, Never>
        
    }
    
    struct Output {
        let answerPublisher: AnyPublisher<AlertType, Never>
        let onReloadPublisher: AnyPublisher<Void, Never>
    }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        setupSignUpButton(input)
        
        let output = Output(
            answerPublisher: answerSubject.eraseToAnyPublisher(),
            onReloadPublisher: onReloadSubject.eraseToAnyPublisher()
        )
        
        outputHandler(output)
    }
    
    private func setupSignUpButton(_ input: SignUpViewModel.Input) {
        input.signUpPublisher
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                
                if signUpSectionsModel.checkValidate() {
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        
                        let success = await self.createUser()
                        self.answerSubject.send(success ? .success : .error)
                        if success {
                            signUpSectionsModel.clearAll()
                            onReloadSubject.send()
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    private func createUser() async -> Bool {
        do {
            let tokenResponse = try await userServie.getToken()
            let response = try await userServie.createUser(model: signUpSectionsModel, token: tokenResponse.token)
            return response.success
        } catch {
            return false
        }
    }
}
