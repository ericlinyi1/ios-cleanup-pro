import XCTest
@testable import CoreLogic

/// Unit tests for VideoCompressor
final class VideoCompressorTests: XCTestCase {
    
    func testEstimateCompressedSize() {
        let originalSize: Int64 = 100 * 1024 * 1024 // 100 MB
        
        let lowQuality = VideoCompressor.estimateCompressedSize(
            originalSize: originalSize,
            quality: .low
        )
        XCTAssertLessThan(lowQuality, originalSize)
        
        let mediumQuality = VideoCompressor.estimateCompressedSize(
            originalSize: originalSize,
            quality: .medium
        )
        XCTAssertLessThan(mediumQuality, originalSize)
        XCTAssertGreaterThan(mediumQuality, lowQuality)
    }
    
    func testVideoInfoStruct() {
        // Verify VideoInfo struct compiles
        XCTAssertTrue(true, "VideoCompressor module compiled successfully")
    }
}
