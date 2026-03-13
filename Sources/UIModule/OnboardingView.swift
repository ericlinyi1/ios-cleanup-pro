import SwiftUI

/// Onboarding view with photo library permission request
/// Updated for Issue #10: Multi-language Support
struct OnboardingView: View {
    @State private var showingPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 15) {
                Text("onboarding.title".i18n)
                    .font(.system(size: 32, weight: .bold))
                
                Text("onboarding.permission.message".i18n)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            Button(action: {
                showingPermissionAlert = true
            }) {
                Text("onboarding.button.allow".i18n)
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
