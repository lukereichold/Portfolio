import UIKit

struct ListManager {
    static func addDefaultList() {
        if Persistence.lists().isEmpty {
            Persistence.createList(withTitle: "Watchlist", isSelected: true)
        }
    }

    static func currentList() -> List {
        return Persistence.lists().first { $0.isSelected }!
    }
}
