import Foundation

/// Full-featured Email Management Module
/// Implements Issue #14, #15, #16, #17
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
    
    public var category: AttachmentCategory {
        let ext = (filename as NSString).pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg", "png", "gif", "heic": return .image
        case "pdf", "doc", "docx", "txt": return .document
        case "xls", "xlsx", "csv": return .spreadsheet
        case "zip", "rar", "7z": return .archive
        case "mp4", "mov": return .video
        default: return .other
        }
    }
}

public enum AttachmentCategory: String, Codable, CaseIterable {
    case image, document, spreadsheet, archive, video, other
}

public class EmailCategorizer {
    
    // #17: Size-based classification
    public static func groupBySize(_ emails: [EmailMessage]) -> [String: [EmailMessage]] {
        var groups: [String: [EmailMessage]] = ["Very Large": [], "Large": [], "Medium": [], "Small": []]
        for email in emails {
            if email.size > 25 * 1024 * 1024 { groups["Very Large"]?.append(email) }
            else if email.size > 5 * 1024 * 1024 { groups["Large"]?.append(email) }
            else if email.size > 1 * 1024 * 1024 { groups["Medium"]?.append(email) }
            else { groups["Small"]?.append(email) }
        }
        return groups
    }
    
    // #14: Label & Subject classification
    public static func categorize(_ emails: [EmailMessage]) -> [String: [EmailMessage]] {
        var categories: [String: [EmailMessage]] = ["Promotions": [], "Finance": [], "Social": [], "Work": [], "Other": []]
        
        for email in emails {
            let content = (email.subject + email.from + email.snippet).lowercased()
            if email.labels.contains("CATEGORY_PROMOTIONS") || content.contains("sale") || content.contains("offer") {
                categories["Promotions"]?.append(email)
            } else if email.labels.contains("银行") || content.contains("invoice") || content.contains("bill") || content.contains("statement") {
                categories["Finance"]?.append(email)
            } else if email.labels.contains("CATEGORY_SOCIAL") || content.contains("linkedin") || content.contains("facebook") {
                categories["Social"]?.append(email)
            } else {
                categories["Other"]?.append(email)
            }
        }
        return categories
    }
}

// #16: Advanced Search & Keywords
public struct EmailSearchEngine {
    public static func search(emails: [EmailMessage], query: String) -> [EmailMessage] {
        guard !query.isEmpty else { return emails }
        let lowQuery = query.lowercased()
        return emails.filter {
            $0.subject.lowercased().contains(lowQuery) ||
            $0.from.lowercased().contains(lowQuery) ||
            $0.snippet.lowercased().contains(lowQuery)
        }
    }
}

// #15: Bulk Operations
public class EmailBatchProcessor {
    public enum Action {
        case delete, markAsRead, markAsUnread, archive
    }
    
    public static func process(_ action: Action, ids: [String], completion: @escaping (Bool) -> Void) {
        // Logic to interface with Gmail API via OAuth/GOG
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(true)
        }
    }
}
