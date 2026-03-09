import Foundation
import CryptoKit

struct PhotoAsset {
    let id: String
    let data: Data
}

class DuplicateDetector {
    /// 核心算法：通过计算 Data 的 SHA256 哈希值来判断文件是否完全一致
    func findExactDuplicates(assets: [PhotoAsset]) -> [[String]] {
        var hashTable: [String: [String]] = [:]
        
        for asset in assets {
            let hash = SHA256.hash(data: asset.data).compactMap { String(format: "%02x", $0) }.joined()
            if hashTable[hash] != nil {
                hashTable[hash]?.append(asset.id)
            } else {
                hashTable[hash] = [asset.id]
            }
        }
        
        // 只返回包含超过一个 ID 的组（即重复组）
        return hashTable.values.filter { $0.count > 1 }
    }
}
