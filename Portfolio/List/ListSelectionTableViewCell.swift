import UIKit
import IoniconsKit

final class ListSelectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var symbolsCountLabel: UILabel!
    @IBOutlet private weak var selectedLabel: UILabel!

    var list: List? {
        didSet {
            refreshData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedLabel.font = .ionicon(of: 48)
        selectedLabel.textColor = .primaryBlue
        selectedLabel.text = .ionicon(with: .iosCheckmarkEmpty)
    }

    private func refreshData() {
        guard let data = list else { return }
        nameLabel.text = data.name
        symbolsCountLabel.text = listCountString(for: data)
        selectedLabel.isHidden = !data.isSelected
    }

    private func listCountString(for list: List) -> String {
        let token = list.stocks.count == 1 ? "symbol" : "symbols"
        return "\(list.stocks.count) \(token)"
    }

}
