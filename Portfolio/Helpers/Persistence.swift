import UIKit
import Disk

struct Persistence {

    // MARK: - All Symbols

    static let all_symbols_path = "all_symbols.json"

    static func saveSymbols(_ symbolData: Data) {
        try? Disk.save(symbolData, to: .caches, as: all_symbols_path)
    }

    static func allSymbols() -> [Stock]? {
        let symbols = try? Disk.retrieve(all_symbols_path, from: .caches, as: [Stock].self)
        return symbols
    }
}
