import UIKit
import Piano
import PullToDismiss

final class ListSelectionViewController: UIViewController {

    private let cellReuseId = "ListSelectionTableViewCell"
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var pullToDismiss: PullToDismiss?

    private var listData: [List] {
        return Persistence.lists()
    }

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
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

    // MARK: - Actions

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func addButtonTapped() {
        showAddListPrompt()
    }

    // MARK: - List Mutation

    private func addNewList(withTitle title: String) {
        Persistence.createList(withTitle: title)

        🎹.play([.hapticFeedback(.impact(.light))])
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: listData.endIndex - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }

    private func removeListRequested(at indexPath: IndexPath) {
        guard listData.count > 1 else {
            showCannotDeleteListAlert()
            return
        }
        showListRemovalConfirmation(for: indexPath)
    }

    private func showListRemovalConfirmation(for indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you would like to delete this list? All symbols you have added to it will be lost.", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let list = self.listData[indexPath.row]
            Persistence.removeList(withUuid: list.uuid)
            🎹.play([.hapticFeedback(.impact(.light))])
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = .primaryBlue
        present(alert, animated: true, completion: nil)
    }

    private func showCannotDeleteListAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let attributedTitle = NSMutableAttributedString(
            string: "Cannot remove only list",
            attributes: [NSAttributedStringKey.font: UIFont.mediumFontOfSize(size: 18)]
        )
        alert.setValue(attributedTitle, forKey: "attributedTitle")

        let attributedMessage = NSMutableAttributedString(
            string: "You need at least one list to track symbols. You can rename this list or create a new one.",
            attributes: [NSAttributedStringKey.font: UIFont.regularFontOfSize(size: 14)]
        )
        alert.setValue(attributedMessage, forKey: "attributedMessage")

        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.view.tintColor = .primaryBlue
        present(alert, animated: true, completion: nil)
    }

    // MARK: - List Interaction

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
            self.removeListRequested(at: indexPath)
        }

        let rename = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            self.showRenameListPrompt(forIndexPath: indexPath)
        }
        rename.backgroundColor = .primaryBlue

        return [delete, rename]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        🎹.play([.hapticFeedback(.impact(.light))])

        let list = listData[indexPath.row]
        guard !list.isSelected else { return }

        Persistence.selectList(withUuid: list.uuid)

        // To make the checkmark animate in
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()

        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! ListSelectionTableViewCell

        let list = listData[indexPath.row]
        cell.list = list
        return cell
    }
}
