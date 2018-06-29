import UIKit
import Piano

protocol StockDetailViewControllerObserver: class {
    func currentListUpdated()
}

final class StockDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listSelectionContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectionContainer: ListSelectionPickerView!
    private let addToListButton = UIButton()

    weak var observer: StockDetailViewControllerObserver?

    private var lists: [List] = Persistence.lists()

    var stock: Stock? {
        didSet {
            setup()
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.HomeScreen.backgroundGrey

        nameLabel.text = stock!.name
        setupListSelectionContainer()
    }

    private func setup() {
        NavigationBarCustomizer.customizeStockDetailScreen(forController: self, title: stock!.symbol)
        setupAddToListButton()
    }

    private func setupListSelectionContainer() {
        listSelectionContainerBottomConstraint.constant = -listSelectionContainer.frame.height
        listSelectionContainer.delegate = self
        listSelectionContainer.stock = stock
        listSelectionContainer.lists = lists
    }

    private func setupAddToListButton() {
        addToListButton.setTitle(String.ionicon(with: .plusRound), for: .normal)
        addToListButton.titleLabel?.font = .ionicon(of: 28)
        addToListButton.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .normal)
        addToListButton.setTitleColor(UIColor.NavBar.buttonNormal, for: .highlighted)
        addToListButton.addTarget(self, action: #selector(toggleListSelectionDrawer), for: .touchUpInside)

        let listButton = UIBarButtonItem(customView: addToListButton)
        listButton.accessibilityLabel = "Add to list"
        navigationItem.rightBarButtonItem = listButton
    }

    @objc private func toggleListSelectionDrawer() {
        let isClosed = listSelectionContainerBottomConstraint.constant != 0
        if isClosed {
            openListSelectionDrawer()
        } else {
            closeListSelectionDrawer()
        }
    }

    private func closeListSelectionDrawer() {
        let offset: CGFloat =  -listSelectionContainer.frame.height
        addToListButton.titleLabel?.font = .ionicon(of: 28)
        
        UIView.animate(withDuration: 0.25) {
            self.listSelectionContainerBottomConstraint.constant = offset
            self.addToListButton.setTitle(String.ionicon(with: .plusRound), for: .normal)
            self.addToListButton.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .normal) // in animate block?
            self.addToListButton.setTitleColor(UIColor.NavBar.buttonNormal, for: .highlighted)
            self.view.layoutIfNeeded()
        }
    }

    private func openListSelectionDrawer() {
        🎹.play([.hapticFeedback(.impact(.medium))])
        let offset: CGFloat = 0
        addToListButton.titleLabel?.font = .ionicon(of: 26)
        UIView.animate(withDuration: 0.25) {
            self.listSelectionContainerBottomConstraint.constant = offset
            self.addToListButton.setTitle(String.ionicon(with: .closeRound), for: .normal)
            self.addToListButton.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal) // in animate block?
            self.addToListButton.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)
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
