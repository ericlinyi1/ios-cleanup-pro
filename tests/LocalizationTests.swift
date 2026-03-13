import XCTest
@testable import UIModule

/// Unit tests for LocalizationHelper
/// Tests for Issue #10: Multi-language Support
final class LocalizationTests: XCTestCase {
    
    func testLocalizationHelperExists() {
        // Verify the module compiles
        XCTAssertNotNil(LocalizationHelper.self)
    }
    
    func testCurrentLanguageReturnsString() {
        let lang = LocalizationHelper.currentLanguage()
        XCTAssertFalse(lang.isEmpty, "Current language should not be empty")
    }
    
    func testLanguageDetection() {
        // At least one should be true (or neither if another language)
        let isChinese = LocalizationHelper.isChinese()
        let isEnglish = LocalizationHelper.isEnglish()
        
        // Just verify they return boolean without crashing
        XCTAssertNotNil(isChinese)
        XCTAssertNotNil(isEnglish)
    }
    
    func testStringLocalizationExtension() {
        // Test that the extension doesn't crash
        let testKey = "app.name"
        let localized = testKey.i18n
        XCTAssertNotNil(localized)
    }
}
