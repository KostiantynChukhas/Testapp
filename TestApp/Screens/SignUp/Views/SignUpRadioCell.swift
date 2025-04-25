import UIKit

class SignUpRadioCell: BaseTableViewCell {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(RadioCell.self, forCellReuseIdentifier: RadioCell.identifierCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 48
        return tableView
    }()
    
    private(set) var items: [SignUpRadioModel] = []
    private var header: String = ""
    private var selectedItems: SimpleClosure<String> = { _ in }
    var selectedIndex: SimpleClosure<Int> = { _ in }
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(tableView)
        
        backgroundView?.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func configure(_ values: [String], header: String) {
        var items: [SignUpRadioModel] = values.compactMap { .init(value: $0, isSelected: false)}
        items[0].isSelected = true
        
        self.items = items
        self.header = header
        
        tableView.snp.updateConstraints { make in
            make.height.equalTo(54*values.count)
        }
        
        tableView.reloadData()
    }
    
    func bind(to model: SignUpSectionsModel) {
        let index = self.items.firstIndex(where: {$0.isSelected}) ?? 1
        model.updateRadioValue(newValue: index + 1)
    }
}

extension SignUpRadioCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RadioCell = tableView.dequeueReusableCell(withIdentifier: RadioCell.identifierCell, for: indexPath) as? RadioCell else { return UITableViewCell() }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension SignUpRadioCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in items.indices {
            items[index].isSelected = (index == indexPath.row)
        }
        selectedItems(items.first(where: {$0.isSelected})?.value ?? "" )
        selectedIndex(indexPath.row + 1)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        let label = UILabel()
        label.font = .init(size: 18)
        label.textColor = UIColor(resource: .text)
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        label.text = self.header
        headerView.backgroundColor = .clear
        headerView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
            $0.top.equalToSuperview()
        }
        
        return headerView
    }
}

