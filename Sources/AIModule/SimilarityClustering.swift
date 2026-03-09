import Foundation
import Vision

struct PhotoEmbedding {
    let id: String
    let featurePrint: [Float] // 模拟 Vision 框架生成的 FeaturePrint 向量
}

class SimilarityClustering {
    /// 使用余弦相似度计算两张照片的相似性
    func calculateCosineSimilarity(_ vectorA: [Float], _ vectorB: [Float]) -> Float {
        guard vectorA.count == vectorB.count else { return 0 }
        let dotProduct = zip(vectorA, vectorB).map(*).reduce(0, +)
        let magnitudeA = sqrt(vectorA.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(vectorB.map { $0 * $0 }.reduce(0, +))
        return dotProduct / (magnitudeA * magnitudeB)
    }
    
    /// 将相似照片聚类，阈值默认 0.9 (高度相似)
    func clusterSimilarPhotos(embeddings: [PhotoEmbedding], threshold: Float = 0.9) -> [[String]] {
        var clusters: [[String]] = []
        var visited = Set<String>()
        
        for i in 0..<embeddings.count {
            if visited.contains(embeddings[i].id) { continue }
            var currentCluster = [embeddings[i].id]
            visited.insert(embeddings[i].id)
            
            for j in (i+1)..<embeddings.count {
                if visited.contains(embeddings[j].id) { continue }
                let similarity = calculateCosineSimilarity(embeddings[i].featurePrint, embeddings[j].featurePrint)
                if similarity >= threshold {
                    currentCluster.append(embeddings[j].id)
                    visited.insert(embeddings[j].id)
                }
            }
            if currentCluster.count > 1 { clusters.append(currentCluster) }
        }
        return clusters
    }
}
