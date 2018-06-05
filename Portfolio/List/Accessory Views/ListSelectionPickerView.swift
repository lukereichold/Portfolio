import UIKit

final class ListSelectionPickerView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()

        setupShadow()
    }

    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
    }


}
