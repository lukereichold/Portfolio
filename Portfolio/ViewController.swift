import UIKit
import Floaty

class ListViewController: UIViewController {

    let cellReuseId = "CELL_ID"
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self


        // always remember to retain this provider somewhere while making requests
//        NetworkAdapter.fetchAllSymbols { symbols in
//            symbols?.forEach {
//                print($0)
//            }
//        }

        let floaty = Floaty()
        floaty.addItem(title: "Hello, World!")
        view.addSubview(floaty)
        
        setupNavBar()
    }

    private func setupNavBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController

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