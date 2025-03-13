import Foundation

extension Country {
    var countryCurrencies: [Currency] {
        return Array((currencies ?? [:]).values)
    }

    var countryLanguages: [String] {
        return Array((languages ?? [:]).values)
    }

    var flagImageURL: URL? {
        return flags?[Constants.pngFormat]
    }
}

fileprivate struct Constants {
    static let pngFormat = "png"
}
