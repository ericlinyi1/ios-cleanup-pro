import math

def cosine_similarity(v1, v2):
    sum_xx, sum_yy, sum_xy = 0, 0, 0
    for i in range(len(v1)):
        x = v1[i]; y = v2[i]
        sum_xx += x*x; sum_yy += y*y; sum_xy += x*y
    return sum_xy / math.sqrt(sum_xx * sum_yy)

def test_clustering():
    # 模拟特征向量：p1 和 p3 非常接近（相似），p2 完全不同
    p1 = [1.0, 0.1, 0.0]
    p2 = [0.0, 1.0, 0.0]
    p3 = [0.95, 0.12, 0.01] 
    
    library = [("IMG_A", p1), ("IMG_B", p2), ("IMG_C", p3)]
    threshold = 0.9
    
    clusters = []
    visited = set()
    for i in range(len(library)):
        if library[i][0] in visited: continue
        cluster = [library[i][0]]
        visited.add(library[i][0])
        for j in range(i+1, len(library)):
            sim = cosine_similarity(library[i][1], library[j][1])
            if sim >= threshold:
                cluster.append(library[j][0])
                visited.add(library[j][0])
        if len(cluster) > 1: clusters.append(cluster)
    
    print(f"Similarity Clusters: {clusters}")
    return clusters

if __name__ == "__main__":
    res = test_clustering()
    assert len(res) == 1
    assert "IMG_A" in res[0] and "IMG_C" in res[0]
    print("✅ Similarity Logic Test Passed!")
