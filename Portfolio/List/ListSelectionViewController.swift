import UIKit
import PullToDismiss

final class ListSelectionViewController: UIViewController {

    private let cellReuseId = "ListSelectionCell"
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var pullToDismiss: PullToDismiss?

    private var data = ["1", "2", "3", "4", "5"]

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
            textField.clearButtonMode = .whileEditing
        }

        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        addPrompt.view.tintColor = .primaryBlue
        addPrompt.addAction(createAction)
        addPrompt.addAction(cancelAction)
        addPrompt.preferredAction = createAction
        present(addPrompt, animated: true, completion: nil)
    }

}

extension ListSelectionViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        }

        let rename = UITableViewRowAction(style: .normal, title: "Rename") { (action, indexPath) in
            // rename item at indexPath
        }

        rename.backgroundColor = .primaryBlue

        return [delete, rename]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // WIP
    }
}

extension ListSelectionViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)

        cell.textLabel?.font = .regularFontOfSize(size: 16)
        cell.textLabel?.text = "This is some text: \(data[indexPath.row])"
        cell.backgroundColor = .clear
        return cell
    }
}
