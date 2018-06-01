import Foundation

struct List: Codable {
    var name: String
    var stocks: [Stock]
    let dateCreated: Date
    let uuid: UUID
    var isSelected: Bool

    init(name: String,
         stocks: [Stock] = [],
         dateCreated: Date = Date(),
         uuid: UUID = UUID(),
         isSelected: Bool = false) {
        self.name = name
        self.stocks = stocks
        self.dateCreated = dateCreated
        self.uuid = uuid
        self.isSelected = isSelected
    }

    mutating func toggleSelected() {
        isSelected = !isSelected
    }
}
