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

    // MARK: - List Management

    static let lists_path = "lists.json"

    static func lists() -> [List]? {
        let lists = try? Disk.retrieve(lists_path, from: .documents, as: [List].self)
        return lists
    }

    static func addList(_ list: List) {
        try? Disk.append(list, to: lists_path, in: .documents)
    }

}
