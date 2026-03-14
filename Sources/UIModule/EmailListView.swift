import SwiftUI
import CoreLogic

/// Main Email List UI for iOS Cleanup Pro
/// Implements Issue #13
public struct EmailListView: View {
    @State private var emails: [EmailMessage] = []
    @State private var selectedTab = "All"
    @State private var searchText = ""
    
    public var body: some View {
        NavigationView {
            VStack {
                // Search Bar (#16)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("search.placeholder".i18n, text: $searchText)
                }
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
                
                // Categorization Tabs (#14)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        CategoryTab(title: "All", isSelected: selectedTab == "All")
                        CategoryTab(title: "Promotions", isSelected: selectedTab == "Promotions")
                        CategoryTab(title: "Finance", isSelected: selectedTab == "Finance")
                        CategoryTab(title: "Large", isSelected: selectedTab == "Large")
                    }
                    .padding(.horizontal)
                }
                
                // Email List
                List {
                    ForEach(filteredEmails) { email in
                        EmailRow(email: email)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("tab.emails".i18n)
        }
    }
    
    private var filteredEmails: [EmailMessage] {
        let searched = EmailSearchEngine.search(emails: emails, query: searchText)
        // Add tab filtering logic here
        return searched
    }
}

struct EmailRow: View {
    let email: EmailMessage
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(email.from).font(.headline)
                Spacer()
                Text(email.date, style: .time).font(.caption).foregroundColor(.gray)
            }
            Text(email.subject).font(.subheadline).lineLimit(1)
            Text(email.snippet).font(.caption).foregroundColor(.gray).lineLimit(2)
        }
        .padding(.vertical, 5)
    }
}

struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(isSelected ? Color.purple : Color.clear)
            .foregroundColor(isSelected ? .white : .purple)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.purple, lineWidth: 1)
            )
    }
}
