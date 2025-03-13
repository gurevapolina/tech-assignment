import Foundation

/// API  for fetching information about countries.
protocol CountriesAPI {
    func allCountries() async throws -> [Country]
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

    func allCountries() async throws -> [Country] {
        return try await commonNetworkService.loadData(urlString: Constants.allCountriesUrlString)
    }
}
