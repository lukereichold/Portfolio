import Foundation

struct List: Codable {
    let name: String
    let stocks: [Stock]
    let dateCreated: Date

    // TODO: stocks should be mutable
}
