import Foundation

final class CommonNetworkService {

    func loadData(
        urlString: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            assertionFailure("URL are not valid")
            return
        }
        loadData(url: url, completion: completion)
    }

    func loadData(
        url: URL?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = url else {
            assertionFailure("URL are not valid")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
                return
            }
        }
        task.resume()
    }
}
