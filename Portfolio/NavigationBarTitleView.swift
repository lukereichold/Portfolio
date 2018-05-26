import UIKit

protocol NavigationTitleButtonObserver: class {
    func titleTapped()
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
        let highlightedTitle = attributedTitle(for: title, color: UIColor.lightGray)

        setAttributedTitle(normalTitle, for: .normal)
        setAttributedTitle(highlightedTitle, for: .highlighted)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        listSettingsObserver?.titleTapped()
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
}
