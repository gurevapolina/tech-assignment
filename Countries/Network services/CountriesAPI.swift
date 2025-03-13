import Foundation

/// API  for fetching information about countries.
protocol CountriesAPI {
    func allCountries(completion: @escaping (Result<[Country], Error>) -> Void)
}

final class CountriesAPIImpl: CountriesAPI {

    private struct Constants {
        static let allCountriesUrlString = "https://restcountries.com/v3.1/all"
    }

    private let commonNetworkService: CommonNetworkService

    init(
        commonNetworkService: CommonNetworkService = ApplicationManager.shared.commonNetworkService
    ) {
        self.commonNetworkService = commonNetworkService
    }

    func allCountries(
        completion: @escaping (Result<[Country], Error>) -> Void
    ) {
        commonNetworkService.loadData(urlString: Constants.allCountriesUrlString) { result in
            switch result {
            case .success(let data):
                let countries = self.parseJSON(data, modelClass: [Country].self)
                completion(.success(countries ?? []))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func parseJSON<T>(_ jsonData: Data, modelClass: T.Type) -> T? where T: Decodable {
        let result = try? JSONDecoder().decode(modelClass,from: jsonData)
        return result
    }
}
