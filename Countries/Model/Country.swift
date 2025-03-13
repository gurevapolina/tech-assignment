import Foundation

struct Country: Codable {
    struct CountryName: Codable {
        let common: String
        let official: String
    }
    
    struct Currency: Codable {
        let name: String
        let symbol: String?
    }
    
    let area: Float
    let population: Int
    let name: CountryName
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: String?
    let subregion: String?
    let languages: [String: String]?
    let flags: [String: URL]?
}
