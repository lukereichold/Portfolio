import UIKit
import Piano

final class ListViewController: UIViewController {

    let cellReuseId = "CELL_ID"
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

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
        refresh()
    }

    private func refresh() {
        NavigationBarCustomizer.customize(forController: self, title: ListManager.currentList().name)
    }

    @objc private func refreshTableData() {
        NetworkAdapter.fetchAllSymbols { symbols in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
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
}

extension ListViewController: FloatingButtonObserver {
    func buttonTapped() {
        🎹.play([.hapticFeedback(.impact(.medium))])
        let symbolSearchVC = storyboard?.instantiateViewController(withIdentifier: "SymbolSearchViewController") as! SymbolSearchViewController
        symbolSearchVC.modalPresentationStyle = .overCurrentContext
//        symbolSearchVC = self
        navigationController?.present(symbolSearchVC, animated: true, completion: nil)
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
        refresh()
    }
}

extension ListViewController: UITableViewDelegate {

}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        cell.textLabel?.font = .regularFontOfSize(size: 16)
        cell.textLabel?.text = "Custom row \(indexPath.row)"
        cell.backgroundColor = .clear
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //
//    }
}
