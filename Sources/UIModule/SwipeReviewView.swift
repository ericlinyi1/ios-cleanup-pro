import SwiftUI

struct SwipeReviewView: View {
    @State private var offset: CGSize = .zero
    @State private var photos = ["photo1", "photo2", "photo3"] // Mock data
    
    var body: some View {
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
