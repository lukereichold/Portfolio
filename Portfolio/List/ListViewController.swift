import UIKit
import Piano

final class ListViewController: UIViewController {

    let cellReuseId = "CELL_ID"
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear

        // always remember to retain this provider somewhere while making requests
//        NetworkAdapter.fetchAllSymbols { symbols in
//            symbols?.forEach {
//                print($0)
//            }
//        }

        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        NavigationBarCustomizer.listSettingsDelegate = self
        NavigationBarCustomizer.listSelectionButtonObserver = self
        NavigationBarCustomizer.customize(forController: self, title: "Watchlist")
        setupFloatingButton()
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
        let searchVC = SymbolSearchViewController()
        navigationController?.present(searchVC, animated: true, completion: nil)
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

        let renameButton = UIAlertAction(title: "Rename", style: .default)
        { _ in
            print("Rename")
        }
        actionSheet.addAction(renameButton)

        let deleteActionButton = UIAlertAction(title: "Delete", style: .destructive)
        { _ in
            print("Delete")
        }
        actionSheet.addAction(deleteActionButton)

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelActionButton)

        navigationController?.present(actionSheet, animated: true, completion: nil)
    }
}

extension ListViewController: ListSelectionButtonObserver {
    func listSelectionButtonTapped() {
        🎹.play([.hapticFeedback(.impact(.medium))])
        let listSelectionVC = ListSelectionViewController()
        listSelectionVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(listSelectionVC, animated: true, completion: nil)
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
