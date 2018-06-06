import UIKit

struct ListManager {
    static func addDefaultListIfNeeded() {
        if Persistence.lists().isEmpty {
            Persistence.addList(defaultList())
        }
    }

    static func defaultList() -> List {
        return List(name: "Watchlist", isSelected: true)
    }

    static func currentList() -> List {
        return Persistence.lists().first { $0.isSelected }!
    }

}
