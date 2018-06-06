import UIKit
import Piano

final class StockDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listSelectionContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectionContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    private var lists: [List] = Persistence.lists()

    var stock: Stock? {
        didSet {
            setup()
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        listSelectionContainerBottomConstraint.constant = -listSelectionContainer.frame.height

        listSelectionContainer.layer.masksToBounds = false
        listSelectionContainer.layer.shadowOffset = CGSize(width: 1, height: 1)
        listSelectionContainer.layer.shadowRadius = 6
        listSelectionContainer.layer.shadowOpacity = 0.5

        nameLabel.text = stock!.name

        pickerView.showsSelectionIndicator = true

        let selectedList = ListManager.currentList()
        if let defaultListIndex = lists.index(of: selectedList) {
            pickerView.selectRow(defaultListIndex, inComponent: 0, animated: false)
        }
    }

    private func setup() {
        NavigationBarCustomizer.customizeStockDetailScreen(forController: self, title: stock!.symbol)
        setupAddToListButton()
    }

    private func setupAddToListButton() {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .plusRound), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)
        button.addTarget(self, action: #selector(toggleListSelectionDrawer), for: .touchUpInside)

        let listButton = UIBarButtonItem(customView: button)
        listButton.accessibilityLabel = "Add to list"
        navigationItem.rightBarButtonItem = listButton
    }

    @IBAction func addToListSubmitTapped(_ sender: Any) {
        toggleListSelectionDrawer()

        let selectedRow = pickerView.selectedRow(inComponent: 0)
        // Event this up ....

        // Refactor these 3 lines
        let list = lists[selectedRow]
        Persistence.addStockToList(list: list, stock: stock!.iexId)
        lists = Persistence.lists()
        pickerView.reloadAllComponents()
    }

    @IBAction func addToListCancelTapped(_ sender: Any) {
        toggleListSelectionDrawer()
    }
    
    @objc private func toggleListSelectionDrawer() {
        let isClosed = listSelectionContainerBottomConstraint.constant != 0
        if isClosed {
            🎹.play([.hapticFeedback(.impact(.medium))])
        }

        var newOffset: CGFloat = 0
        if !isClosed {
            newOffset = -listSelectionContainer.frame.height
        }
        UIView.animate(withDuration: 0.25) {
            self.listSelectionContainerBottomConstraint.constant = newOffset
            self.view.layoutIfNeeded()
        }
    }
}

extension StockDetailViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let disableRow = lists[row].stocks.contains(stock!.iexId)

        let label = view as? UILabel ?? UILabel()
        label.font = .mediumFontOfSize(size: 20)
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
}

extension StockDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists.count
    }
}
