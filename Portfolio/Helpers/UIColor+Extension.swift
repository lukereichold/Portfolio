import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    struct HomeScreen {
        static let backgroundGrey = UIColor(white: 249/255.0, alpha: 1)
    }

    static let primaryBlue = UIColor(red: 42, green: 122, blue: 194)
    static let darkBlack = UIColor(red: 12, green: 12, blue: 12) // coming soon

    struct NavBar {
        static let buttonNormal = UIColor.black
        static let buttonHighlighted = UIColor.primaryBlue
    }

    struct FloatingButton {
        static let buttonNormal = UIColor.primaryBlue
    }
}

