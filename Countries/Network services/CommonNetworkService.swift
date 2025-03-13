import Foundation

enum NetworkError: Error {
    case invalidURL
    case parsingError
}

final class CommonNetworkService {
    func loadData<T>(urlString: String) async throws -> T where T: Decodable {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        return try await loadData(url: url)
    }

    func loadData<T>(url: URL?) async throws -> T where T: Decodable {
        guard let url else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        if let result = parseJSON(data, modelClass: T.self) {
            return result
        } else {
            throw NetworkError.parsingError
        }
    }

    private func parseJSON<T>(_ jsonData: Data, modelClass: T.Type) -> T? where T: Decodable {
        let result = try? JSONDecoder().decode(modelClass, from: jsonData)
        return result
    }
}
