import UIKit
import Piano
import IoniconsKit

final class ListViewController: UIViewController {

    let cellReuseId = "CELL_ID"
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var placeholderLabel: UILabel!

    private lazy var stocks: [Stock] = stocksInCurrentList()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)

        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        NavigationBarCustomizer.listSettingsDelegate = self
        NavigationBarCustomizer.listSelectionButtonObserver = self
        setupFloatingButton()
        NavigationBarCustomizer.customize(forController: self, title: ListManager.currentList().name)
        navigationController?.navigationBar.tintColor = .darkBlack
        title = ""
    }

    // MARK: - Private

    private func updateViewForCurrentList() {
        NavigationBarCustomizer.customize(forController: self, title: ListManager.currentList().name)
        refreshTableData()
    }

    @objc private func refreshTableData() {
        stocks = stocksInCurrentList()
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    private func stocksInCurrentList() -> [Stock] {
        return ListManager.currentList().stocks
    }

    // Show placeholder when list becomes empty (don't need to reload after every removal)
    private func stockWasRemoved() {
        stocks = stocksInCurrentList()
        if stocks.isEmpty {
            refreshTableData()
        }
    }

    private func setupFloatingButton() {
        let searchButton = FloatingButton()
        searchButton.observer = self
        view.addSubview(searchButton)

        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17),
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -17),
            searchButton.widthAnchor.constraint(equalToConstant: 58),
            searchButton.heightAnchor.constraint(equalToConstant: 58),
            ])
    }

    private func launchDetailForStock(_ stock: Stock) {
        let stockDetailVC = storyboard?.instantiateViewController(withIdentifier: "StockDetailViewController") as! StockBaseViewController
        stockDetailVC.stock = stock
        stockDetailVC.observer = self
        navigationController?.pushViewController(stockDetailVC, animated: true)
    }
}

extension ListViewController: FloatingButtonObserver {
    func buttonTapped() {
        🎹.play([.hapticFeedback(.impact(.medium))])
        let symbolSearchVC = storyboard?.instantiateViewController(withIdentifier: "SymbolSearchViewController") as! SymbolSearchViewController
        symbolSearchVC.modalPresentationStyle = .overCurrentContext
        symbolSearchVC.observer = self
        navigationController?.present(symbolSearchVC, animated: true, completion: nil)
    }
}

extension ListViewController: SymbolSearchViewControllerObserver {
    func launchStockDetailRequested(forStock stock: Stock) {
        launchDetailForStock(stock)
    }
}

extension ListViewController: StockDetailViewControllerObserver {
    func currentListUpdated() {
        updateViewForCurrentList()
    }
}

extension ListViewController: NavigationTitleButtonObserver {
    func navigationBarTitleTapped(withTitle title: String) {
        🎹.play([.hapticFeedback(.impact(.medium))])
        showListMutationActionSheet(forList: title)
    }

    private func showListMutationActionSheet(forList listTitle: String) {
        let actionSheet = UIAlertController(title: nil, message: "List '\(listTitle)'", preferredStyle: .actionSheet)
        let shareButton = UIAlertAction(title: "Share", style: .default, handler: nil)
        actionSheet.addAction(shareButton)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelActionButton)

        navigationController?.present(actionSheet, animated: true, completion: nil)
    }
}

extension ListViewController: ListSelectionButtonObserver {
    func listSelectionButtonTapped() {
        🎹.play([.hapticFeedback(.impact(.medium))])
        let listSelectionVC = storyboard?.instantiateViewController(withIdentifier: "ListSelectionViewController") as! ListSelectionViewController
        listSelectionVC.modalPresentationStyle = .overCurrentContext
        listSelectionVC.observer = self
        navigationController?.present(listSelectionVC, animated: true, completion: nil)
    }
}

extension ListViewController: ListSelectionViewControllerObserver {
    func selectedListChanged() {
        updateViewForCurrentList()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { (action, view, handler) in
            let stock = self.stocks[indexPath.row]
            🎹.play([.hapticFeedback(.impact(.light))])
            Persistence.removeStockFromList(list: ListManager.currentList(), stock: stock)
            handler(true)
            self.stockWasRemoved()
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = .ionicon(with: .iosTrash, textColor: .white, size: CGSize(width: 35, height: 35))

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let showPlaceholder = stocks.count == 0
        if showPlaceholder {
            placeholderLabel.fadeIn(0.2)
        } else {
            placeholderLabel.fadeOut(0)
        }
        return stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        // TODO: use custom cell type

        let stock = stocks[indexPath.row]
        cell.textLabel?.font = .regularFont(ofSize: 16)
        cell.textLabel?.text = stock.symbol
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let stock = stocks[indexPath.row]
        launchDetailForStock(stock)
    }
}
