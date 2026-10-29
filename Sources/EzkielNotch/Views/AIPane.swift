import SwiftUI
import NotchCore
import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String
    let content: String
}

struct AIPane: View {
    @ObservedObject var model: AppModel
    @State private var chatInput: String = ""
    @State private var messages: [ChatMessage] = [] 
    @State private var isSending = false

    var body: some View {
        VStack(spacing: 0) {
            // Header AI
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(Accent.stash.deep)
                Text("AI Companion").font(Theme.font(Theme.Size.body, .bold))
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.2))
            
            // Riwayat Chat
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        Text(message.content)
                            .font(.system(size: 13))
                            .padding(8)
                            .background(message.role == "user" ? Accent.stash.deep.opacity(0.2) : Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(maxWidth: .infinity, alignment: message.role == "user" ? .trailing : .leading)
                    }
                }
                .padding()
            }
            
            // Input Area
            HStack(spacing: 8) {
                TextField("Tanya apa saja...", text: $chatInput)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
                .disabled(isSending || chatInput.isEmpty)
            }
            .padding()
        }
        .background(Theme.ink.opacity(0.05))
    }
    
    private func sendMessage() {
        let userMessage = chatInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userMessage.isEmpty else { return }

        messages.append(ChatMessage(role: "user", content: userMessage))
        chatInput = ""
        isSending = true

        Task {
            do {
                let url = URL(string: "http://localhost:8787/v1/chat/completions")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let body: [String: Any] = [
                    "model": "gpt-4o",
                    "messages": messages.map { ["role": $0.role, "content": $0.content] }
                ]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                
                let (data, _) = try await URLSession.shared.data(for: request)
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let choices = json?["choices"] as? [[String: Any]]
                let content = choices?.first?["message"] as? [String: Any]
                
                if let response = content?["content"] as? String {
                    messages.append(ChatMessage(role: "assistant", content: response))
                }
            } catch {
                messages.append(ChatMessage(role: "assistant", content: "Error: \(error.localizedDescription)"))
            }
            isSending = false
        }
    }
}
