import SwiftUI

/// Swipe-based photo review interface
/// Updated for Issue #10: Multi-language Support
struct SwipeReviewView: View {
    @State private var offset: CGSize = .zero
    @State private var photos = ["photo1", "photo2", "photo3"] // Mock data
    
    var body: some View {
        VStack {
            Text("review.title".i18n)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            ZStack {
                ForEach(photos.indices, id: \.self) { index in
                    CardView(imageName: photos[index])
                        .offset(index == photos.count - 1 ? offset : .zero)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if index == photos.count - 1 {
                                        offset = gesture.translation
                                    }
                                }
                                .onEnded { _ in
                                    if abs(offset.width) > 100 {
                                        // Handle delete (left) or keep (right)
                                        photos.removeLast()
                                    }
                                    offset = .zero
                                }
                        )
                }
            }
            .padding()
            
            HStack(spacing: 40) {
                Text("review.swipeLeft".i18n)
                    .foregroundColor(.red)
                    .font(.headline)
                
                Text("review.swipeRight".i18n)
                    .foregroundColor(.green)
                    .font(.headline)
            }
            .padding()
            
            Text("review.hint".i18n)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
    }
}

struct CardView: View {
    let imageName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.gray.opacity(0.2))
            .overlay(
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                    Text(imageName)
                }
            )
            .frame(height: 500)
            .shadow(radius: 10)
    }
}
