import hashlib

def simulate_duplicate_check():
    # 模拟 3 张照片，其中 A 和 C 是完全一样的字节流
    photo_a = b"dummy_image_data_1"
    photo_b = b"dummy_image_data_2"
    photo_c = b"dummy_image_data_1"
    
    library = [
        {"id": "IMG_001", "data": photo_a},
        {"id": "IMG_002", "data": photo_b},
        {"id": "IMG_003", "data": photo_c}
    ]
    
    hash_map = {}
    for photo in library:
        h = hashlib.sha256(photo["data"]).hexdigest()
        if h in hash_map:
            hash_map[h].append(photo["id"])
        else:
            hash_map[h] = [photo["id"]]
            
    result = [ids for ids in hash_map.values() if len(ids) > 1]
    print(f"--- Duplicate Detection Report ---")
    print(f"Library size: {len(library)}")
    print(f"Duplicates found: {result}")
    return result

if __name__ == "__main__":
    res = simulate_duplicate_check()
    if len(res) == 1 and "IMG_001" in res[0] and "IMG_003" in res[0]:
        print("✅ LOGIC TEST PASSED: Accurate byte-level matching.")
    else:
        print("❌ LOGIC TEST FAILED.")
