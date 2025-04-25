import UIKit
import Combine

class BaseTableViewCell: UITableViewCell {
    var cancellables = Set<AnyCancellable>()
    
    static var identifierCell: String {
        String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        makeConstraints()
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundView?.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureView() { }
    func makeConstraints() { }
}

