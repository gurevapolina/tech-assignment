import Foundation
import UIKit

protocol ImagesLoader {
    func loadImage(url: URL?) async throws -> UIImage?
}

final class ImagesLoaderImpl: ImagesLoader {
    func loadImage(url: URL?) async throws -> UIImage? {
        guard let url else {
            return nil
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}
