import UIKit

final class StockDetailViewController: UIViewController {

    var stock: Stock? {
        didSet {
            setup()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setup() {
        NavigationBarCustomizer.customizeStockDetailScreen(forController: self, title: stock!.symbol)
    }


    @IBAction func addToListTapped(_ sender: Any) {

    }
}
