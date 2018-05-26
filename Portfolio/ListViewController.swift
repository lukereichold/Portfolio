import UIKit
import Floaty
import IoniconsKit

class ListViewController: UIViewController {

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

        setTitle("Watchlist")
        view.backgroundColor = UIColor.HomeScreen.backgroundGrey
        NavigationBarCustomizer.customize(forController: self)
        setupFloatingButton()
    }

    // TODO: refactor this into the NavigationBarCustomizer or a custom class
    private func setTitle(_ title: String) {
        let button = UIButton()
        let normalTitle = attributedTitle(for: title, color: .black)
        let highlightedTitle = attributedTitle(for: title, color: UIColor.lightGray)

        button.setAttributedTitle(normalTitle, for: .normal)
        button.setAttributedTitle(highlightedTitle, for: .highlighted)
        navigationItem.titleView = button
    }

    private func attributedTitle(for title: String,
                                 color: UIColor) -> NSAttributedString {
        let titleString = NSAttributedString(string: "\(title)  ", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                                NSAttributedStringKey.font: UIFont.regularFontOfSize(size: 18)])

        let attributedTitle = NSMutableAttributedString(attributedString: titleString)

        let downString = NSAttributedString(string: String.ionicon(with: .iosArrowDown), attributes: [NSAttributedStringKey.font: UIFont.ionicon(of: 14)])
        attributedTitle.append(downString)
        return attributedTitle
    }

    private func setupFloatingButton() {
        let floaty = Floaty()
        floaty.plusColor = .clear
        floaty.buttonColor = UIColor.FloatingButton.buttonNormal
        floaty.buttonImage = .ionicon(with: .iosPlusEmpty, textColor: UIColor.white, size: CGSize(width: 38, height: 38))
        view.addSubview(floaty)
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

        cell.textLabel?.text = "Custom row \(indexPath.row)"
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //
//    }
}
