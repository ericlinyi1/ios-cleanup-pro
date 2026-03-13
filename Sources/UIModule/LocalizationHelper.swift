import Foundation

/// Localization helper for accessing localized strings
/// Implements Issue #10: Multi-language Support
public struct LocalizationHelper {
    
    /// Get localized string with key
    /// - Parameters:
    ///   - key: Localization key from Localizable.strings
    ///   - comment: Optional comment for translators
    /// - Returns: Localized string
    public static func localized(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
    
    /// Get localized string with formatted arguments
    /// - Parameters:
    ///   - key: Localization key
    ///   - arguments: Arguments to format into the string
    /// - Returns: Formatted localized string
    public static func localized(_ key: String, _ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: arguments)
    }
    
    /// Get current app language code
    /// - Returns: Language code (e.g., "en", "zh-Hans")
    public static func currentLanguage() -> String {
        return Locale.preferredLanguages.first ?? "en"
    }
    
    /// Check if current language is Chinese
    /// - Returns: True if Chinese (any variant)
    public static func isChinese() -> Bool {
        let lang = currentLanguage()
        return lang.hasPrefix("zh")
    }
    
    /// Check if current language is English
    /// - Returns: True if English
    public static func isEnglish() -> Bool {
        let lang = currentLanguage()
        return lang.hasPrefix("en")
    }
    
    /// Get display name for language code
    /// - Parameter code: Language code (e.g., "en", "zh-Hans")
    /// - Returns: Display name in current locale
    public static func displayName(for code: String) -> String? {
        return Locale.current.localizedString(forLanguageCode: code)
    }
}

// MARK: - Convenient String Extension
public extension String {
    /// Get localized version of this string (assuming it's a key)
    var i18n: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Get localized version with formatted arguments
    func i18n(_ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String(format: format, arguments: arguments)
    }
}
