import Foundation

typealias Symbol = String
typealias UniqueStockIdentifier = String

struct Stock: Codable {
    let symbol: Symbol
    let name: String
    let isEnabled: Bool
    let type: String
    let iexId: UniqueStockIdentifier
}

extension Stock: Equatable {
    static func ==(lhs: Stock, rhs: Stock) -> Bool {
        return lhs.iexId == rhs.iexId
    }
}
