import UIKit
import PullToDismiss

protocol SymbolSearchViewControllerObserver: class {
    func launchStockDetailRequested(forStock stock: Stock)
}

final class SymbolSearchViewController: UIViewController {

    private let cellReuseId = "SymbolSelectionTableViewCell"
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placeholderLabel: UILabel!
    private var pullToDismiss: PullToDismiss?
    weak var observer: SymbolSearchViewControllerObserver?

    private lazy var unfilteredStocks: [Stock] = {
        return Persistence.allSymbols()
    }()

    private var filteredStocks = [Stock]()

    private func filterResultsForQuery(_ searchQuery: String) {
        guard let searchQuery = searchBar.text, !searchQuery.isEmpty else {
            filteredStocks = []
            tableView.reloadData()
            return
        }
        DispatchQueue.global(qos: .background).async { [unowned self] in
            self.filteredStocks = self.unfilteredStocks.filter { stock in
                let lowerCasedQuery = searchQuery.lowercased()
                let symbolMatch = stock.symbol.lowercased().starts(with: lowerCasedQuery)
                let companyMatch = stock.name.lowercased().starts(with: lowerCasedQuery)
                return companyMatch || symbolMatch
            }

            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self

        title = ""
        setupNavBar()
        setupSearchBar()

        pullToDismiss = PullToDismiss(scrollView: tableView, viewController: self, navigationBar: navigationBar)
        pullToDismiss?.delegate = self
        pullToDismiss?.backgroundEffect = nil

        DispatchQueue.global(qos: .background).async { [unowned self] in
            _ = self.unfilteredStocks
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }

    private func setupNavBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        setupCloseButton()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.font = .regularFont(ofSize: 17)
    }

    private func setupCloseButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setTitle(String.ionicon(with: .closeRound), for: .normal)
        button.titleLabel?.font = .ionicon(of: 26)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.customView = button
        closeButton.accessibilityLabel = "Close"
    }

    // MARK: - Actions

    @objc private func closeButtonTapped() {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}

extension SymbolSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let stock = filteredStocks[indexPath.row]
        dismiss(animated: false, completion: nil)
        observer?.launchStockDetailRequested(forStock: stock)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension SymbolSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var showPlaceholder = false
        if let text = searchBar.text {
            showPlaceholder = filteredStocks.count == 0 && !text.isEmpty
        }

        placeholderLabel.isHidden = !showPlaceholder
        return filteredStocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! SymbolSelectionTableViewCell

        let cellData = filteredStocks[indexPath.row]
        cell.data = cellData
        return cell
    }
}

extension SymbolSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResultsForQuery(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
