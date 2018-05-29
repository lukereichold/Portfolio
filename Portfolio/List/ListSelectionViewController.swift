import UIKit
import PullToDismiss

final class ListSelectionViewController: UIViewController {

    private let cellReuseId = "ListSelectionCell"
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var pullToDismiss: PullToDismiss?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never // do we still need this?

        pullToDismiss = PullToDismiss(scrollView: tableView, viewController: self, navigationBar: navigationBar)
        pullToDismiss?.backgroundEffect = nil
        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        setupNavBar()
    }

    private func setupNavBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        setupCloseButton()
    }

    func setupCloseButton() {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .closeRound), for: .normal)
        button.titleLabel?.font = .ionicon(of: 26)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.customView = button
        closeButton.accessibilityLabel = "Close"
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension ListSelectionViewController: UITableViewDataSource {

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
}
