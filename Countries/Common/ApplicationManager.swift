import Foundation

final class ApplicationManager {

    static let shared = ApplicationManager()

    let commonNetworkService = CommonNetworkService()
    let imagesCacheManager: ImagesCacheManager = ImagesCacheManagerImpl()

    private init() {}
}
