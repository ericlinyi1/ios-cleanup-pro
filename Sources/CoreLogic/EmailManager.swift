import Foundation

/// Email message model for processing and cleanup
/// Implements part of Issue #14, #16, #17
public struct EmailMessage: Identifiable, Codable {
    public let id: String
    public let threadId: String
    public let from: String
    public let subject: String
    public let snippet: String
    public let date: Date
    public let size: Int64
    public let labels: [String]
    public let attachments: [EmailAttachment]
    public var isRead: Bool
    
    public init(id: String, threadId: String, from: String, subject: String, snippet: String, date: Date, size: Int64, labels: [String], attachments: [EmailAttachment], isRead: Bool) {
        self.id = id
        self.threadId = threadId
        self.from = from
        self.subject = subject
        self.snippet = snippet
        self.date = date
        self.size = size
        self.labels = labels
        self.attachments = attachments
        self.isRead = isRead
    }
}

public struct EmailAttachment: Identifiable, Codable {
    public let id: String
    public let filename: String
    public let mimeType: String
    public let size: Int64
    
    public init(id: String, filename: String, mimeType: String, size: Int64) {
        self.id = id
        self.filename = filename
        self.mimeType = mimeType
        self.size = size
    }
    
    /// Categorize attachment by file type
    public var category: AttachmentCategory {
        let ext = (filename as NSString).pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg", "png", "gif", "heic": return .image
        case "pdf", "doc", "docx", "txt", "pages": return .document
        case "xls", "xlsx", "csv", "numbers": return .spreadsheet
        case "zip", "rar", "7z", "tar": return .archive
        case "mp4", "mov", "avi": return .video
        default: return .other
        }
    }
}

public enum AttachmentCategory: String, Codable, CaseIterable {
    case image, document, spreadsheet, archive, video, other
}

/// Core logic for email categorization and filtering
public class EmailCategorizer {
    
    /// Categorize emails by size ranges
    /// Implements part of Issue #17
    public static func groupBySize(_ emails: [EmailMessage]) -> [String: [EmailMessage]] {
        var groups: [String: [EmailMessage]] = [
            "Very Large (>25MB)": [],
            "Large (10MB-25MB)": [],
            "Medium (1MB-10MB)": [],
            "Small (<1MB)": []
        ]
        
        for email in emails {
            if email.size > 25 * 1024 * 1024 {
                groups["Very Large (>25MB)"]?.append(email)
            } else if email.size > 10 * 1024 * 1024 {
                groups["Large (10MB-25MB)"]?.append(email)
            } else if email.size > 1 * 1024 * 1024 {
                groups["Medium (1MB-10MB)"]?.append(email)
            } else {
                groups["Small (<1MB)"]?.append(email)
            }
        }
        return groups
    }
    
    /// Categorize emails by attachment file type
    /// Implements part of Issue #17
    public static func groupByAttachmentType(_ emails: [EmailMessage]) -> [AttachmentCategory: [EmailMessage]] {
        var groups: [AttachmentCategory: [EmailMessage]] = [:]
        for cat in AttachmentCategory.allCases { groups[cat] = [] }
        
        for email in emails {
            let uniqueCategories = Set(email.attachments.map { $0.category })
            for cat in uniqueCategories {
                groups[cat]?.append(email)
            }
        }
        return groups
    }
    
    /// Filter emails by keyword in subject or body
    /// Implements part of Issue #16
    public static func filterByKeyword(_ emails: [EmailMessage], keyword: String) -> [EmailMessage] {
        let lowKeyword = keyword.lowercased()
        return emails.filter { 
            $0.subject.lowercased().contains(lowKeyword) || 
            $0.snippet.lowercased().contains(lowKeyword) ||
            $0.from.lowercased().contains(lowKeyword)
        }
    }
    
    /// Analyze subject to detect categories like Promotions, Receipts
    /// Implements part of Issue #14
    public static func analyzeSubjects(_ emails: [EmailMessage]) -> [String: [EmailMessage]] {
        var groups: [String: [EmailMessage]] = ["Promotions": [], "Receipts": [], "Social": [], "Other": []]
        
        let promoKeywords = ["sale", "off", "deal", "discount", "offer", "limited time", "newsletter"]
        let receiptKeywords = ["receipt", "order", "invoice", "payment", "confirmed", "billing"]
        let socialKeywords = ["notification", "message", "tagged", "commented", "followed"]
        
        for email in emails {
            let subject = email.subject.lowercased()
            if promoKeywords.contains(where: { subject.contains($0) }) {
                groups["Promotions"]?.append(email)
            } else if receiptKeywords.contains(where: { subject.contains($0) }) {
                groups["Receipts"]?.append(email)
            } else if socialKeywords.contains(where: { subject.contains($0) }) {
                groups["Social"]?.append(email)
            } else {
                groups["Other"]?.append(email)
            }
        }
        return groups
    }
}

/// Processor for bulk email actions
/// Implements Issue #15
public class EmailBatchProcessor {
    
    public enum BatchAction {
        case delete
        case markAsRead
        case markAsUnread
        case addLabel(String)
        case removeLabel(String)
    }
    
    /// Execute a batch action on a list of emails
    /// - Parameters:
    ///   - action: The action to perform
    ///   - emails: Target email messages
    ///   - completion: Completion callback
    public static func execute(action: BatchAction, on emails: [EmailMessage], completion: @escaping (Bool, Error?) -> Void) {
        // In actual implementation, this would call Gmail REST API batch endpoints
        // For now, we simulate the logic structure
        
        print("Executing \(action) on \(emails.count) emails...")
        
        // Simulating network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(true, nil)
        }
    }
}

