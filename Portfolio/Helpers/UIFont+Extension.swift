import UIKit

// refer to http://iosfonts.com for strings
extension UIFont {
    class func regularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size)!
    }

    class func mediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }

    class func boldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }

    class func italicFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Italic", size: size)!
    }

    class func lightFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-UltraLight", size: size)!
    }

}
