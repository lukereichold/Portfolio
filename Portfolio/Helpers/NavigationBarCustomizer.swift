import UIKit

final class NavigationBarCustomizer {

    static weak var listSettingsDelegate: NavigationTitleButtonObserver?

    static func customize(forController controller: UIViewController,
                          title: String) {
        setupSearchButton(for: controller)
        setupMenuButton(for: controller)
        setupTitle(title, in: controller)
        makeTransparent(for: controller)
    }

    private static func setupTitle(_ title: String,
                                   in controller: UIViewController) {
        let titleView = NavigationBarTitleView(title: title)
        titleView.listSettingsObserver = listSettingsDelegate
        controller.navigationItem.titleView = titleView
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
