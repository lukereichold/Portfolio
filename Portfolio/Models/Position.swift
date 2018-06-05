import UIKit

struct Position: Codable {
    let symbol: Symbol
    let count: Int
    let purchasePrice: Decimal
    let uuid: UUID
}
