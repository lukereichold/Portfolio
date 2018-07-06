import UIKit
import Piano
import SwiftMessages
import Parchment

protocol StockDetailViewControllerObserver: class {
    func currentListUpdated()
}

final class StockBaseViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listSelectionContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectionContainer: ListSelectionPickerView!
    private let addToListButton = AnimatingPlusButton()

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
        setupPagingControl()
    }

    private func setupPagingControl() {
        let vc1 = UIViewController()
        vc1.title = "Charts"
        let vc2 = UIViewController()
        vc2.title = "Positions"
        let vc3 = UIViewController()
        vc3.title = "Alerts"
        let vc4 = UIViewController()
        vc4.title = "News"

        let pagingViewController = FixedPagingViewController(viewControllers: [
            vc1, vc2, vc3, vc4
            ])
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 90, height: 40)

        add(pagingViewController)

        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
    }

    private func setup() {
        NavigationBarCustomizer.customizeStockDetailScreen(forController: self, title: stock!.symbol)
        setupAddToListButton()
    }

    // MARK: - Add to list functionality

    private func setupListSelectionContainer() {
        listSelectionContainerBottomConstraint.constant = -listSelectionContainer.frame.height
        listSelectionContainer.delegate = self
        listSelectionContainer.stock = stock
        listSelectionContainer.lists = lists
    }

    private func setupAddToListButton() {
        addToListButton.observer = self
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
        let offset: CGFloat = -listSelectionContainer.frame.height
        addToListButton.buttonStateIsExpanded = false
        UIView.animate(withDuration: 0.25) {
            self.listSelectionContainerBottomConstraint.constant = offset
            self.view.layoutIfNeeded()
        }
    }

    private func openListSelectionDrawer() {
        🎹.play([.hapticFeedback(.impact(.medium))])
        let offset: CGFloat = 0
        UIView.animate(withDuration: 0.25) {
            self.listSelectionContainerBottomConstraint.constant = offset
            self.view.layoutIfNeeded()
        }
    }

    private func showListAdditionSuccessBanner(forList list: String) {

        let view = NotificationBannerFactory.stockAddedBanner(withStock: stock!.symbol, list: list)
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 1.5)
        config.dimMode = .none
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: config, view: view)

        🎹.play([.hapticFeedback(.impact(.light))])
    }
}

extension StockBaseViewController: PlusButtonObserver {
    func buttonTapped() {
        toggleListSelectionDrawer()
    }
}

extension StockBaseViewController: ListSelectionPickerViewDelegate {
    func addToListTapped(withList list: List) {
        toggleListSelectionDrawer()
        Persistence.addStockToList(list: list, stock: stock!)
        listSelectionContainer.lists = Persistence.lists()

        if list.isSelected {
            observer?.currentListUpdated()
        }

        showListAdditionSuccessBanner(forList: list.name)
    }

    func dismissTapped() {
        toggleListSelectionDrawer()
    }
}
