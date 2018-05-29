import Foundation

struct List: Codable {
    let name: String
    let symbols: [Stock]
    let dateCreated: Date
}
