import Foundation
import UIKit

protocol ImagesLoader {
    func loadImage(
        url: URL?,
        completion: @escaping (Result<UIImage, Error>) -> Void
    )
}

final class ImagesLoaderImpl: ImagesLoader {
    private let commonNetworkService: CommonNetworkService

    init(
        commonNetworkService: CommonNetworkService = ApplicationManager.shared.commonNetworkService
    ) {
        self.commonNetworkService = commonNetworkService
    }

    func loadImage(
        url: URL?,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        commonNetworkService.loadData(url: url) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
