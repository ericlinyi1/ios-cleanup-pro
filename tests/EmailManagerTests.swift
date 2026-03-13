import XCTest
@testable import CoreLogic

final class EmailManagerTests: XCTestCase {
    
    var mockEmails: [EmailMessage] = []
    
    override func setUp() {
        super.setUp()
        let now = Date()
        mockEmails = [
            EmailMessage(id: "1", threadId: "t1", from: "netflix@netflix.com", subject: "Your subscription renewal", snippet: "Renew now", date: now, size: 50000, labels: ["Inbox"], attachments: [], isRead: false),
            EmailMessage(id: "2", threadId: "t2", from: "boss@work.com", subject: "Urgent: Project Alpha", snippet: "Needs review", date: now, size: 15000000, labels: ["Inbox", "Work"], attachments: [EmailAttachment(id: "a1", filename: "specs.pdf", mimeType: "application/pdf", size: 5000000)], isRead: true),
            EmailMessage(id: "3", threadId: "t3", from: "spam@ads.com", subject: "Special Offer: 50% OFF", snippet: "Click here", date: now, size: 200000, labels: ["Promotions"], attachments: [EmailAttachment(id: "a2", filename: "banner.jpg", mimeType: "image/jpeg", size: 100000)], isRead: false),
            EmailMessage(id: "4", threadId: "t4", from: "bank@service.com", subject: "Monthly Invoice - March", snippet: "View your bill", date: now, size: 30000000, labels: ["Finance"], attachments: [EmailAttachment(id: "a3", filename: "invoice.pdf", mimeType: "application/pdf", size: 1000000)], isRead: false)
        ]
    }
    
    func testGroupBySize() {
        let groups = EmailCategorizer.groupBySize(mockEmails)
        XCTAssertEqual(groups["Very Large (>25MB)"]?.count, 1) // ID 4
        XCTAssertEqual(groups["Large (10MB-25MB)"]?.count, 1) // ID 2
        XCTAssertEqual(groups["Small (<1MB)"]?.count, 2) // ID 1, 3
    }
    
    func testGroupByAttachmentType() {
        let groups = EmailCategorizer.groupByAttachmentType(mockEmails)
        XCTAssertEqual(groups[.document]?.count, 2) // ID 2, 4 (PDFs)
        XCTAssertEqual(groups[.image]?.count, 1) // ID 3 (JPG)
    }
    
    func testSubjectAnalysis() {
        let analysis = EmailCategorizer.analyzeSubjects(mockEmails)
        XCTAssertEqual(analysis["Promotions"]?.count, 1) // ID 3 (Special Offer)
        XCTAssertEqual(analysis["Receipts"]?.count, 1) // ID 4 (Invoice)
    }
    
    func testBatchProcessorSimulation() {
        let expectation = self.expectation(description: "Batch processing completion")
        EmailBatchProcessor.execute(action: .delete, on: [mockEmails[0]]) { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
