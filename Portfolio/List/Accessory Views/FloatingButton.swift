import UIKit
import IoniconsKit

protocol FloatingButtonObserver: class {
    func buttonTapped()
}

final class FloatingButton: UIControl {

    weak var observer: FloatingButtonObserver?
    private let size: CGFloat = 58

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.6 : 1.0
        }
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.FloatingButton.buttonNormal
        layer.cornerRadius = min(frame.height, frame.width) / 2.0
        applyShadow()
        setButtonImage()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        isAccessibilityElement = true
        accessibilityLabel = "Search"
        accessibilityTraits |= UIAccessibilityTraitButton
    }

    @objc private func buttonTapped() {
        observer?.buttonTapped()
    }

    private func applyShadow() {
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
    }

    private func setButtonImage() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.font = .ionicon(of: 32)
        label.text = .ionicon(with: .iosSearchStrong)
        label.textColor = .white
        label.sizeToFit()
        label.center = center
        addSubview(label)
    }

}
