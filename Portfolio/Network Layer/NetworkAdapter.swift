import Moya
import Disk

// TODO: should these really be static methods? Only concern is around creating multiple MoyaProviders for every request.
// TODO: handle errors back from `request` method

struct NetworkAdapter {
    static let provider = MoyaProvider<StockService>()

    static func fetchAllSymbols(persistData: Bool = true,
                                completion: @escaping ([Stock]?) -> Void) {

        request(target: .allSymbols,
            success: { (filteredResponse) in
                Persistence.saveSymbols(filteredResponse.data)
                let symbols: [Stock] = Persistence.allSymbols()
                completion(symbols)
            }, error: { (error) in
                completion(nil)
            }, failure: { (moyaError) in
                completion(nil)
            }
        )
    }

    static func request(target: StockService,
                        success successCallback: @escaping (Response) -> Void,
                        error errorCallback: @escaping (Swift.Error) -> Void,
                        failure failureCallback: @escaping (MoyaError) -> Void) {

        provider.request(target) { (result) in
            switch result {
            case .success(let moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    successCallback(filteredResponse)
                } catch {
                    // Here we get either statusCode error
                    let error = NSError(domain: "com.reikam.portfolio", code: 0, userInfo: [NSLocalizedDescriptionKey: "Bad response code: \(moyaResponse.statusCode)"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
}
