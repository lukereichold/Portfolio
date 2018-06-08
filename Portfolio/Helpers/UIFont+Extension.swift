import UIKit

// refer to http://iosfonts.com for strings
extension UIFont {
    class func regularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }

    class func mediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }

    class func boldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }

    class func italicFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Italic", size: size)!
    }

    class func lightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-UltraLight", size: size)!
    }

}
