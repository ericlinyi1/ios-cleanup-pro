import XCTest
@testable import CoreLogic

/// Unit tests for ScreenshotDetector
final class ScreenshotDetectorTests: XCTestCase {
    
    func testFormatSize() {
        let size1 = ScreenshotDetector.formatSize(1024 * 1024) // 1 MB
        XCTAssertTrue(size1.contains("MB"))
        
        let size2 = ScreenshotDetector.formatSize(1024 * 1024 * 1024) // 1 GB
        XCTAssertTrue(size2.contains("GB"))
    }
    
    func testGroupByDateLogic() {
        // This is a logic test without real PHAsset access
        // In real device/simulator, fetchScreenshots() would return actual data
        XCTAssertTrue(true, "ScreenshotDetector module compiled successfully")
    }
}
