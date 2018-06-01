import UIKit
import Disk

struct Persistence {

    // MARK: - All Symbols

    static let all_symbols_path = "all_symbols.json"

    static func saveSymbols(_ symbolData: Data) {
        try? Disk.save(symbolData, to: .caches, as: all_symbols_path)
    }

    static func allSymbols() -> [Stock] {
        let symbols = try? Disk.retrieve(all_symbols_path, from: .caches, as: [Stock].self)
        return symbols ?? []
    }

    // MARK: - List Management

    static let lists_path = "lists.json"

    static func lists() -> [List] {
        let lists = try? Disk.retrieve(lists_path, from: .documents, as: [List].self)
        return lists ?? []
    }

    static func createList(withTitle title: String, isSelected: Bool = false) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let newList = List(name: trimmedTitle, isSelected: isSelected)
        addList(newList)
    }

    static func addList(_ list: List) {
        try? Disk.append(list, to: lists_path, in: .documents)
    }

    static func removeList(_ list: List) {
        var updatedLists = lists().filter { $0.uuid != list.uuid }
        if list.isSelected {
            updatedLists[0].isSelected = true
        }
        try? Disk.save(updatedLists, to: .documents, as: lists_path)
    }

    static func selectList(withUuid uuid: UUID) {
        let updatedLists: [List] = lists().map {
            var list = $0
            list.isSelected = (list.uuid == uuid)
            return list
        }
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
