import UIKit
import PullToDismiss

final class SymbolSearchViewController: UIViewController {

    private let cellReuseId = "SymbolSelectionTableViewCell"
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var pullToDismiss: PullToDismiss?

    private lazy var unfilteredStocks: [Stock] = {
        return Persistence.allSymbols()
    }()

    private var filteredStocks: [Stock] {
        guard let searchQuery = searchBar.text, !searchQuery.isEmpty else {
            return []
        }

        return unfilteredStocks.filter { stock in
            let symbolMatch = stock.symbol.lowercased().contains(searchQuery.lowercased())
            if symbolMatch {
                return true
            } else if stock.name.lowercased().contains(searchQuery.lowercased()) {
                return true
            } else {
                return false
            }
//            return companyMatch || symbolMatch
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        
        setupNavBar()
        setupSearchBar()

        pullToDismiss = PullToDismiss(scrollView: tableView, viewController: self, navigationBar: navigationBar)
        pullToDismiss?.delegate = self
        pullToDismiss?.backgroundEffect = nil
//        _ = unfilteredStocks
        // Why am i still getting lag on first launch?
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
        textField?.font = .regularFontOfSize(size: 17)
    }

    private func setupCloseButton() {
        let button = UIButton()
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
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension SymbolSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
