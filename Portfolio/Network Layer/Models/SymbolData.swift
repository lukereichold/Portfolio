import Foundation

typealias Symbol = String

struct SymbolData: Decodable {
    let symbol: Symbol
    let name: String
    let isEnabled: Bool
    let type: String
    let iexId: String
}
