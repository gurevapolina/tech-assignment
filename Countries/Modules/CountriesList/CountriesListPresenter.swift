import Foundation

protocol CountriesListPresenter: AnyObject {
    func countriesListViewDidLoad(_ view: CountriesListView)
    func countriesListViewDidTapTryAgain(_ view: CountriesListView)
    func countriesListViewDidSelectCountry(_ view: CountriesListView, index: Int)
}

final class CountriesListPresenterImpl: CountriesListPresenter {

    // MARK: Properties

    weak var countriesListView: CountriesListView?

    // MARK: Private properties

    private let countriesAPI: CountriesAPI
    private var countries: [Country] = []

    // MARK: Init

    init(
        countriesAPI: CountriesAPI = CountriesAPIImpl()
    ) {
        self.countriesAPI = countriesAPI
    }

    // MARK: CountriesListPresenter

    func countriesListViewDidLoad(_ view: CountriesListView) {
        self.countriesListView = view

        loadCountries()
    }

    func countriesListViewDidTapTryAgain(_ view: CountriesListView) {
        loadCountries()
    }

    func countriesListViewDidSelectCountry(_ view: CountriesListView, index: Int) {
        let country = countries[index]
        openCountryScreen(country: country)
    }

    // MARK: Private methods

    private func loadCountries() {
        countriesListView?.showLoadingVisible(true)
        countriesListView?.showErrorVisible(false)

        Task {
            do {
                let countries = try await countriesAPI.allCountries()
                self.countries = countries.sorted(by: { $0.name.common < $1.name.common })
                self.countriesListView?.showCountries(self.countries)
            } catch {
                self.countriesListView?.showErrorVisible(true)
            }

            await MainActor.run {
                countriesListView?.showLoadingVisible(false)
            }
        }
    }

    private func openCountryScreen(country: Country) {
        let viewController = CountryViewController()
        let imagesLoader = ImagesLoaderImpl()
        let presenter = CountryViewPresenterImpl(country: country, imagesLoader: imagesLoader)
        viewController.presenter = presenter

        countriesListView?.showCountryInfoController(viewController)
    }
}
