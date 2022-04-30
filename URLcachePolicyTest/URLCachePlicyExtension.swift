import Foundation
extension URLRequest.CachePolicy {
    func extractDebugString() -> String {
        switch self {
        case .useProtocolCachePolicy:
            return "useProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData:
            return "reloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData:
            return "reloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad:
            return "returnCacheDataElseLoad"
        case .returnCacheDataDontLoad:
            return "returnCacheDataDontLoad"
        case .reloadRevalidatingCacheData:
            return "reloadRevalidatingCacheData"
        }
    }
}
