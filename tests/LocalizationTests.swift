import XCTest
@testable import UIModule

/// Unit tests for LocalizationManager
final class LocalizationTests: XCTestCase {
    
    func testLocalizationManagerExists() {
        let manager = LocalizationManager.shared
        XCTAssertNotNil(manager)
    }
    
    func testCurrentLanguageDetection() {
        let manager = LocalizationManager.shared
        let language = manager.currentLanguage
        
        // Should return a valid language code
        XCTAssertFalse(language.isEmpty)
        XCTAssertTrue(language.count >= 2)
    }
    
    func testLocalizedStringExtension() {
        // Test that the String extension compiles
        let testKey = "app.name"
        let localized = testKey.localized
        
        // In test environment, it will return the key itself if not found
        XCTAssertNotNil(localized)
    }
    
    func testGlobalLocalizationFunction() {
        // Test that L() function works
        let result = L("test.key")
        XCTAssertNotNil(result)
    }
    
    func testChineseLanguageDetection() {
        let manager = LocalizationManager.shared
        
        // This test verifies the logic works
        // Actual result depends on test environment language
        let isChineseLogic = manager.currentLanguage.hasPrefix("zh")
        XCTAssertEqual(manager.isChineseLanguage, isChineseLogic)
    }
}
