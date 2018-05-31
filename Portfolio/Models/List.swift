import Foundation

struct List: Codable {
    var name: String
    var stocks: [Stock]
    let dateCreated: Date
    let uuid: UUID

    // TODO: stocks should be mutable
}
