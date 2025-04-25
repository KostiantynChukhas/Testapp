import Combine
import UIKit

class LaunchViewModel {
    
    private let coordinator: LaunchCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    
    init(_ coordinator: LaunchCoordinator) {
        self.coordinator = coordinator
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            coordinator.dismiss()
        }
    }
}

extension LaunchViewModel: ViewModelProtocol {
    
    struct Input { }
    
    struct Output { }
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        
        let output = Output()
        
        outputHandler(output)
    }
}
