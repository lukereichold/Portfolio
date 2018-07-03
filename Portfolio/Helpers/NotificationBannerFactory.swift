import UIKit
import SwiftMessages

final class NotificationBannerFactory {

    static func stockAddedBanner(withStock stock: Symbol, list: String) -> MessageView {
        let view: MessageView = try! SwiftMessages.viewFromNib(named: "NotificationBanner")
        view.backgroundColor = .primaryBlue
        view.titleLabel?.font = .regularFont(ofSize: 16)
        view.titleLabel?.text = "\(stock) added to list '\(list)'."
        view.iconLabel?.font = .ionicon(of: 44)
        view.iconLabel?.textColor = .white
        view.iconLabel?.text = .ionicon(with: .iosCheckmarkEmpty)

        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.5
        return view
    }

}
