import Foundation

public protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input, outputHandler: @escaping (_ output: Output) -> Void)
}

public protocol ViewProtocol {
    associatedtype ViewModelType: ViewModelProtocol

    var viewModel: ViewModelType! { get set }

    func setupOutput()
    func setupInput(input: ViewModelType.Output)
}
