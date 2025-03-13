import Foundation
import UIKit

protocol ImagesCacheManager {
    func setObject(image: UIImage, key: NSString)
    func getObject(key: NSString) -> UIImage?
}

final class ImagesCacheManagerImpl: ImagesCacheManager {

    private let cache = NSCache<NSString, UIImage>()

    func setObject(image: UIImage, key: NSString) {
        cache.setObject(image, forKey: key)
    }

    func getObject(key: NSString) -> UIImage? {
        return cache.object(forKey: key)
    }
}
