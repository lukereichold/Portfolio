import UIKit

protocol ListSelectionPickerViewDelegate: class {
    func addToListTapped(withList list: List)
    func dismissTapped()
}

final class ListSelectionPickerView: UIView {

    private let cancelButton = UIButton(type: .system)
    private let addToListButton = UIButton(type: .system)
    private let pickerView = UIPickerView()

    weak var delegate: ListSelectionPickerViewDelegate?

    var stock: Stock?
    var lists: [List]? {
        didSet {
            pickerView.reloadAllComponents()

            let selectedList = ListManager.currentList()
            if let defaultListIndex = lists!.index(of: selectedList) {
                pickerView.selectRow(defaultListIndex, inComponent: 0, animated: false)

                let disableRow = selectedList.stocks.contains(stock!)
                addToListButton.isEnabled = !disableRow
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
        setupViews()
        constrainViews()
    }

    // MARK: - Actions

    @objc private func cancelTapped() {
        delegate?.dismissTapped()
    }

    @objc private func addToListTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let list = lists![selectedRow]
        delegate?.addToListTapped(withList: list)
        pickerView.reloadAllComponents()
    }

    // MARK: - Setup

    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
    }

    private func setupViews() {
        cancelButton.titleLabel?.font = .regularFont(ofSize: 19)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        addSubview(cancelButton)

        addToListButton.titleLabel?.font = .mediumFont(ofSize: 19)
        addToListButton.contentHorizontalAlignment = .right
        addToListButton.setTitle("Add to List", for: .normal)
        addToListButton.setTitleColor(UIColor.primaryBlue, for: .normal)
        addToListButton.setTitleColor(UIColor.primaryBlue.withAlphaComponent(0.3), for: .disabled)
        addToListButton.addTarget(self, action: #selector(addToListTapped), for: .touchUpInside)
        addSubview(addToListButton)

        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        addSubview(pickerView)
    }

    private func constrainViews() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 80),
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            ])

        addToListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addToListButton.widthAnchor.constraint(equalToConstant: 115),
            addToListButton.topAnchor.constraint(equalTo: topAnchor, constant: 5)
            ])

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            ])
    }

}

extension ListSelectionPickerView: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        guard let lists = lists else { return UIView() }
        guard let stock = stock else { return UIView() }

        let disableRow = lists[row].stocks.contains(stock)

        let label = view as? UILabel ?? UILabel()
        label.font = .mediumFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.text = lists[row].name
        if disableRow {
            label.alpha = 0.2
            label.text?.append(" (Already added)")
        }
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let lists = lists else { return }
        guard let stock = stock else { return }

        let disableRow = lists[row].stocks.contains(stock)
        addToListButton.isEnabled = !disableRow
    }
}

extension ListSelectionPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists?.count ?? 0
    }
}
