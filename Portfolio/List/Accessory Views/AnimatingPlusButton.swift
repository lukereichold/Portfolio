import UIKit

protocol PlusButtonObserver: class {
    func buttonTapped()
}

final class AnimatingPlusButton: UIControl {
    weak var observer: PlusButtonObserver?
    private let size = 44
    private let iconView = UILabel()
    var buttonStateIsExpanded = false {
        didSet {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 0.55,
                           initialSpringVelocity: 0.3,
                           options: .curveLinear, animations: {
                            let rotation = self.buttonStateIsExpanded ? CGAffineTransform(rotationAngle: CGFloat.pi / 4) : .identity
                            self.iconView.transform = rotation
            }, completion: nil)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            // ideally, make icon black
            alpha = isHighlighted ? 0.3 : 1.0
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
        backgroundColor = .clear
        isAccessibilityElement = true
        accessibilityLabel = "Add to list"
        accessibilityTraits |= UIAccessibilityTraitButton
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        iconView.font = .ionicon(of: 30)
        iconView.textColor = UIColor.NavBar.buttonHighlighted
        iconView.text = .ionicon(with: .plusRound)
        iconView.textAlignment = .center
        iconView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        addSubview(iconView)
    }

    @objc private func buttonTapped() {
        buttonStateIsExpanded = !buttonStateIsExpanded
        observer?.buttonTapped()
    }

}
