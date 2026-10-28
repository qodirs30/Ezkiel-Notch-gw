import SwiftUI
import NotchCore

struct AIPane: View {
    @ObservedObject var model: AppModel
    @State private var chatInput: String = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("AI Companion")
                .font(Theme.font(Theme.Size.body, .bold))
                .foregroundStyle(Theme.ink)
            
            TextField("Tanya AI...", text: $chatInput)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack {
                Button("Vision") {
                    // Nanti kita isi logika ScreenCaptureKit di sini
                }
                .buttonStyle(.borderedProminent)
                
                Button("Kirim") {
                    // Logic kirim ke 9Router
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
