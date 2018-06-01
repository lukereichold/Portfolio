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

    static func lists() -> [List] {
        let lists = try? Disk.retrieve(lists_path, from: .documents, as: [List].self)
        return lists ?? []
    }

    static func createList(withTitle title: String, isSelected: Bool = false) {
        let newList = List(name: title, isSelected: isSelected)
        addList(newList)
    }

    static func addList(_ list: List) {
        try? Disk.append(list, to: lists_path, in: .documents)
    }

    static func removeList(withUuid uuid: UUID) {
        let updatedLists = lists().filter { $0.uuid != uuid }
        try? Disk.save(updatedLists, to: .documents, as: lists_path)
    }

    static func renameList(withUuid uuid: UUID, to newTitle: String) {
        var allLists = lists()
        if let index = allLists.index(where: { $0.uuid == uuid }) {
            allLists[index].name = newTitle
            try? Disk.save(allLists, to: .documents, as: lists_path)
        }
    }
}
