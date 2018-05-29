import Foundation

typealias Symbol = String

struct Stock: Codable {
    let symbol: Symbol
    let name: String
    let isEnabled: Bool
    let type: String
    let iexId: String
}
