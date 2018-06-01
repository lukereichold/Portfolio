import UIKit
import IoniconsKit

class ListSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolsCountLabel: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!

    var list: List? {
        didSet {
//            refreshData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectedLabel.font = .ionicon(of: 28) // blah size
        selectedLabel.text = .ionicon(with: .iosCheckmark)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // TODO
    }

    private func refreshData() {
        guard let data = list else { return }
        nameLabel.text = data.name
        symbolsCountLabel.text = "\(data.stocks.count) symbols"
        selectedLabel.isHidden = !(data.isSelected)
    }

}
