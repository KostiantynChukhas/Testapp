import Foundation
import Combine
import UIKit

public protocol NonReusableViewProtocol: AnyObject {
    associatedtype ViewModelProtocol
    func setupOutput(_ viewModel: ViewModelProtocol)
}

open class ViewController<ViewModel: ViewModelProtocol>: UIViewController,
                                                         ViewProtocol {
    
    // MARK: - Properties
    public var viewModel: ViewModel!
    
    // MARK: - Constructor
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(viewModel: ViewModel,
                nibName: String? = nil,
                bundle: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupConstraints()
        setupOutput()
    }
    
    // MARK: - Setup Functions
    
    /// override to setup constraints. Called in viewDidLoad method.
    /// override to setup views. Called in viewDidLoad method.
    open func setupView() {}
    open func setupConstraints() {}
    
    // MARK: - ViewProtocol
    
    open func setupOutput() {}
    open func setupInput(input: ViewModel.Output) {}
}
