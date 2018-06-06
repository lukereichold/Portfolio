import Foundation

struct List: Codable, Equatable {
    var name: String
    var stocks: [UniqueStockIdentifier]
    let dateCreated: Date
    let uuid: UUID
    var isSelected: Bool

    init(name: String,
         stocks: [UniqueStockIdentifier] = [],
         dateCreated: Date = Date(),
         uuid: UUID = UUID(),
         isSelected: Bool = false) {
        self.name = name
        self.stocks = stocks
        self.dateCreated = dateCreated
        self.uuid = uuid
        self.isSelected = isSelected
    }

    mutating func addStock(_ stockId: UniqueStockIdentifier) {
        stocks.append(stockId)
    }
}
