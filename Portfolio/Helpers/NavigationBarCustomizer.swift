import UIKit

final class NavigationBarCustomizer {

    static weak var listSettingsDelegate: NavigationTitleButtonObserver?

    static func customize(forController controller: UIViewController,
                          title: String) {
        setupTitle(title, in: controller)
        setupMenuButton(for: controller)

        let listButton = createAddListButton()
        controller.navigationItem.rightBarButtonItems = [listButton]

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

    static func setupMenuButton(for controller: UIViewController) {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .iosMoreOutline), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)

        let menuButton = UIBarButtonItem(customView: button)
        menuButton.accessibilityLabel = "Menu"
        controller.navigationItem.leftBarButtonItem = menuButton
    }

    static func createSearchButton() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .iosSearch), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)
        
        let searchButton = UIBarButtonItem(customView: button)
        searchButton.accessibilityLabel = "Search"
        return searchButton
    }

    static func createAddListButton() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle(String.ionicon(with: .iosListOutline), for: .normal)
        button.titleLabel?.font = .ionicon(of: 28)
        button.setTitleColor(UIColor.NavBar.buttonNormal, for: .normal)
        button.setTitleColor(UIColor.NavBar.buttonHighlighted, for: .highlighted)

        let listButton = UIBarButtonItem(customView: button)
        listButton.accessibilityLabel = "Add list"
        return listButton
    }
}
