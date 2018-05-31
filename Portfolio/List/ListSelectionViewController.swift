import UIKit
import PullToDismiss

final class ListSelectionViewController: UIViewController {

    private let cellReuseId = "ListSelectionCell"
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var pullToDismiss: PullToDismiss?

    private var listData: [List] {
        return Persistence.lists() ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self

        pullToDismiss = PullToDismiss(scrollView: tableView, viewController: self, navigationBar: navigationBar)
        pullToDismiss?.delegate = self
        pullToDismiss?.backgroundEffect = nil
        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        setupNavBar()
    }

    private func setupNavBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        setupCloseButton()
        setupAddButton()
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

    private func setupAddButton() {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .plusRound), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.customView = button
        addButton.accessibilityLabel = "Create new list"
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func addButtonTapped() {
        showAddListPrompt()
    }

    private func addNewList(withTitle title: String) {
        Persistence.createList(withTitle: title)

        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: listData.endIndex - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    private func showAddListPrompt() {

        let addPrompt = UIAlertController(title: "", message: nil, preferredStyle: .alert)

        let attributedTitle = NSMutableAttributedString(
            string: "Create New List",
            attributes: [NSAttributedStringKey.font: UIFont.mediumFontOfSize(size: 18)]
        )
        addPrompt.setValue(attributedTitle, forKey: "attributedTitle")

        addPrompt.addTextField { (textField) in
            textField.placeholder = "My Watchlist"
            textField.font = .mediumFontOfSize(size: 16)
            textField.autocorrectionType = .yes
            textField.clearButtonMode = .whileEditing
        }

        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            if let listTitle = addPrompt.textFields?.first?.text {
                self.addNewList(withTitle: listTitle)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        addPrompt.view.tintColor = .primaryBlue
        addPrompt.addAction(createAction)
        addPrompt.addAction(cancelAction)
        addPrompt.preferredAction = createAction
        present(addPrompt, animated: true, completion: nil)
    }

    private func showRenameListPrompt(forIndexPath indexPath: IndexPath) {
        let renamePrompt = UIAlertController(title: "", message: nil, preferredStyle: .alert)

        let attributedTitle = NSMutableAttributedString(
            string: "Rename List",
            attributes: [NSAttributedStringKey.font: UIFont.mediumFontOfSize(size: 18)]
        )
        renamePrompt.setValue(attributedTitle, forKey: "attributedTitle")

        renamePrompt.addTextField { (textField) in
            textField.placeholder = "My Watchlist"
            textField.font = .mediumFontOfSize(size: 16)
            textField.autocorrectionType = .yes
            textField.clearButtonMode = .whileEditing
        }

        let renameAction = UIAlertAction(title: "Rename", style: .default) { (action) in
            if let newTitle = renamePrompt.textFields?.first?.text {
                let list = self.listData[indexPath.row]
                Persistence.renameList(withUuid: list.uuid, to: newTitle)

                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        renamePrompt.view.tintColor = .primaryBlue
        renamePrompt.addAction(renameAction)
        renamePrompt.addAction(cancelAction)
        renamePrompt.preferredAction = renameAction
        present(renamePrompt, animated: true, completion: nil)
    }

}

extension ListSelectionViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let list = self.listData[indexPath.row]
            Persistence.removeList(withUuid: list.uuid)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        let rename = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            self.showRenameListPrompt(forIndexPath: indexPath)
        }

        rename.backgroundColor = .primaryBlue

        return [delete, rename]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // TODO WIP
    }
}

extension ListSelectionViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        let list = listData[indexPath.row]
        cell.textLabel?.font = .regularFontOfSize(size: 16)
        cell.textLabel?.text = list.name
        cell.detailTextLabel?.font = .italicFontOfSize(size: 12)
        cell.detailTextLabel?.text = "\(list.stocks) symbols"
        cell.backgroundColor = .clear
        return cell
    }
}
