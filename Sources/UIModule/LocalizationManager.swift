import Foundation

/// Localization manager for iOS Cleanup Pro
/// Handles multi-language support and string localization
public class LocalizationManager {
    
    /// Shared singleton instance
    public static let shared = LocalizationManager()
    
    private init() {}
    
    /// Get localized string by key
    /// - Parameters:
    ///   - key: Localization key from Localizable.strings
    ///   - arguments: Optional format arguments
    /// - Returns: Localized string
    public func localizedString(_ key: String, _ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        if arguments.isEmpty {
            return format
        }
        return String(format: format, arguments: arguments)
    }
    
    /// Current app language code (e.g., "en", "zh-Hans")
    public var currentLanguage: String {
        return Locale.preferredLanguages.first ?? "en"
    }
    
    /// Check if current language is Chinese
    public var isChineseLanguage: Bool {
        return currentLanguage.hasPrefix("zh")
    }
}

/// Convenience extension for shorter syntax
public extension String {
    /// Get localized version of this string (treated as key)
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Get localized string with format arguments
    func localized(_ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        if arguments.isEmpty {
            return format
        }
        return String(format: format, arguments: arguments)
    }
}

/// Global function for quick localization
public func L(_ key: String, _ arguments: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    if arguments.isEmpty {
        return format
    }
    return String(format: format, arguments: arguments)
}
