import UIKit

struct NavigationBarCustomizer {

    static func customize(forController controller: UIViewController) {
        setupSearchButton(for: controller)
        setupMenuButton(for: controller)
        setupTitle(for: controller)
        makeTransparent(for: controller)
    }

    static func setupTitle(for controller: UIViewController) {
        controller.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont.regularFontOfSize(size: 18)]
    }

    static func makeTransparent(for controller: UIViewController) {
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        controller.navigationController?.navigationBar.isTranslucent = true
    }

    static func setupSearchButton(for controller: UIViewController) {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .iosSearch), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)

        let searchButton = UIBarButtonItem(customView: button)
        searchButton.accessibilityLabel = "Search"
        controller.navigationItem.rightBarButtonItem = searchButton
    }

    static func setupMenuButton(for controller: UIViewController) {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .iosMoreOutline), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)

        let searchButton = UIBarButtonItem(customView: button)
        searchButton.accessibilityLabel = "Menu"
        controller.navigationItem.leftBarButtonItem = searchButton
    }
}
