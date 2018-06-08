import UIKit
import Piano

protocol StockDetailViewControllerObserver: class {
    func currentListUpdated()
}

final class StockDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listSelectionContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectionContainer: ListSelectionPickerView!

    weak var observer: StockDetailViewControllerObserver?

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

        listSelectionContainer.delegate = self
        listSelectionContainer.lists = lists
        listSelectionContainer.stock = stock
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

extension StockDetailViewController: ListSelectionPickerViewDelegate {
    func addToListTapped(withList list: List) {
        toggleListSelectionDrawer()
        Persistence.addStockToList(list: list, stock: stock!)
        listSelectionContainer.lists = Persistence.lists()

        if list.isSelected {
            observer?.currentListUpdated()
        }
    }

    func dismissTapped() {
        toggleListSelectionDrawer()
    }
}
