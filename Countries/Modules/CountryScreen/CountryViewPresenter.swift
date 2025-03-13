import Foundation
import UIKit

fileprivate enum AdditionalInfoKey {
    case officialName
    case capitalNames
    case languagies
    case currency
    case area
    case pupulation
}

protocol CountryViewPresenter: AnyObject {
    func countryViewDidLoad(_ view: CountryView)
}

final class CountryViewPresenterImpl: CountryViewPresenter {

    // MARK: Properties

    weak var countryView: CountryView?

    // MARK: Private properties

    private let country: Country
    private let imagesLoader: ImagesLoader
    private let imagesCacheManager: ImagesCacheManager

    // MARK: Init

    init(
        country: Country,
        imagesLoader: ImagesLoader = ImagesLoaderImpl(),
        imagesCacheManager: ImagesCacheManager = ApplicationManager.shared.imagesCacheManager
    ) {
        self.country = country
        self.imagesLoader = imagesLoader
        self.imagesCacheManager = imagesCacheManager
    }

    // MARK: CountryViewPresenter

    func countryViewDidLoad(_ view: CountryView) {
        self.countryView = view

        let presentable = CountryViewPresentable(
            navigationItemTitle: country.name.common,
            additionalInfoStrings: configureAdditionalInfoStrings()
        )
        countryView?.updateCountryInfo(presentable: presentable)

        loadFlagImage()
    }

    // MARK: Private methods

    private func configureAdditionalInfoStrings() -> [NSAttributedString] {
        let keys: [AdditionalInfoKey] = [
            .officialName,
            .capitalNames,
            .languagies,
            .currency,
            .area,
            .pupulation
        ]
        return keys.map { createAttributedString(additionalInfoKey: $0) }.compactMap({ $0 })
    }

    private func createAttributedString(additionalInfoKey: AdditionalInfoKey) -> NSAttributedString? {
        guard let value = additionalInfoKey.valueTitle(country: country) else { return nil }

        let title = additionalInfoKey.title()
        let resultText = "\(title): \(value)"

        guard
            title.isEmpty == false,
            value.isEmpty == false
        else {
            return nil
        }

        let result = NSMutableAttributedString(string: resultText)

        result.addAttribute(
            NSMutableAttributedString.Key.foregroundColor,
            value: UIColor.darkGray,
            range: NSRange(location: 0, length: title.count + 1)
        )
        result.addAttribute(
            NSMutableAttributedString.Key.foregroundColor,
            value: UIColor.black,
            range: NSRange(location: title.count + 2, length: value.count)
        )
        return NSAttributedString(attributedString: result)
    }

    private func loadFlagImage() {
        if let cachedImage = imagesCacheManager.getObject(key: country.imageCacheID) {
            countryView?.showImage(image: cachedImage)
            return
        }

        Task {
            if let image = try? await imagesLoader.loadImage(urlString: country.flagImageURL) {
                imagesCacheManager.setObject(image: image, key: country.imageCacheID)
                countryView?.showImage(image: image)
            }
        }
    }
}

extension AdditionalInfoKey {
    fileprivate func title() -> String {
        switch self {
        case .officialName: return "Official name"
        case .capitalNames: return "Capital"
        case .languagies: return "Language"
        case .currency: return "Currency"
        case .area: return "Area"
        case .pupulation: return "Population"
        }
    }

    fileprivate func valueTitle(country: Country) -> String? {
        switch self {
        case .officialName:
            return country.name.official

        case .capitalNames:
            return (country.capital ?? []).joined(separator: ",")

        case .languagies:
            return country.countryLanguages.joined(separator: ",")

        case .currency:
            return country.countryCurrencies
                .map { currency in
                    var result = currency.name 
                    if let symbol = currency.symbol {
                        result += " (\(symbol))"
                    }
                    return result
                }
                .joined(separator: ",")

        case .area:
            if let area = country.area {
                return "\(area)"
            } else {
                return nil
            }

        case .pupulation:
            if let population = country.population {
                return "\(population)"
            } else {
                return nil
            }
        }
    }
}

extension Country {
    var imageCacheID: NSString {
        return NSString(
            string: [name.common, name.official]
                .compactMap({ $0 })
                .joined(separator: "_")
        )
    }
}
