import Foundation
import UIKit

protocol ImagesLoader {
    func loadImage(urlString: String?) async throws -> UIImage?
}

final class ImagesLoaderImpl: ImagesLoader {
    func loadImage(urlString: String?) async throws -> UIImage? {
        guard let urlString,
              let url = URL(string: urlString)
        else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}
