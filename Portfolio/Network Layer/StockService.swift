import Moya

enum StockService {
    case gainers
    case losers
    case allSymbols
}

extension StockService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.iextrading.com/1.0")!
    }

    var path: String {
        switch self {
        case .gainers:
            return "/stock/market/list/gainers"
        case .losers:
            return "/stock/market/list/losers"
        case .allSymbols:
            return "/ref-data/symbols"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
