import UIKit

protocol NavigationTitleButtonObserver: class {
    func navigationBarTitleTapped(withTitle title: String)
}

final class NavigationBarTitleView: UIButton {

    weak var listSettingsObserver: NavigationTitleButtonObserver?
    private var title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let normalTitle = attributedTitle(for: title, color: .black)
        let highlightedTitle = attributedTitle(for: title, color: .lightGray)

        setAttributedTitle(normalTitle, for: .normal)
        setAttributedTitle(highlightedTitle, for: .highlighted)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        accessibilityLabel = "List Actions"
    }

    @objc private func buttonTapped() {
        listSettingsObserver?.navigationBarTitleTapped(withTitle: title)
    }

    private func attributedTitle(for title: String,
                                 color: UIColor) -> NSAttributedString {
        let titleString = NSAttributedString(string: "\(title)  ", attributes: [NSAttributedStringKey.foregroundColor: color,
                                                                                NSAttributedStringKey.font: UIFont.mediumFont(ofSize: 18)])

        let attributedTitle = NSMutableAttributedString(attributedString: titleString)

        let downString = NSAttributedString(string: String.ionicon(with: .iosArrowDown), attributes: [NSAttributedStringKey.foregroundColor: color,
                                                                                                      NSAttributedStringKey.font: UIFont.ionicon(of: 14)])
        attributedTitle.append(downString)
        return attributedTitle
    }
}
