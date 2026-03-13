import SwiftUI

struct OnboardingView: View {
    @State private var showingPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 15) {
                Text(L("onboarding.title"))
                    .font(.system(size: 32, weight: .bold))
                
                Text(L("onboarding.permission.message"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            Button(action: {
                showingPermissionAlert = true
            }) {
                Text(L("onboarding.button.allow"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding(.horizontal, 30)
            }
            .padding(.bottom, 50)
        }
    }
}
