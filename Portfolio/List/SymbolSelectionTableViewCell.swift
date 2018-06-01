import UIKit

final class SymbolSelectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!

    var data: Stock? {
        didSet {
            refreshData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func refreshData() {
        guard let data = data else { return }
        symbolLabel.text = data.symbol
        companyLabel.text = data.name
    }

}
