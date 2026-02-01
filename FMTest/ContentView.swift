//
//  ContentView.swift
//  FMTest
//
//  Created by Chenluo Deng on 2/1/26.
//

import SwiftUI
import FoundationModels

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct ContentView: View {
    private var model = SystemLanguageModel.default
    let session = LanguageModelSession(instructions: """
        You are a Apple Support Assistant. Help the user with any Apple product related questions they may have.
        """)
    
    @State var text: String = ""
    @State var messages: [Message] = []
    @State var isLoading: Bool = false

    var body: some View {
        switch model.availability {
        case .available:
            chatView
        case .unavailable(.deviceNotEligible):
            UnavailableView(
                icon: "iphone.slash",
                title: "Device Not Eligible",
                message: "This device doesn't support Apple Intelligence features."
            )
        case .unavailable(.appleIntelligenceNotEnabled):
            UnavailableView(
                icon: "brain",
                title: "Apple Intelligence Not Enabled",
                message: "Please enable Apple Intelligence in Settings to use this feature."
            )
        case .unavailable(.modelNotReady):
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Preparing Model...")
                    .font(.headline)
                Text("The model is downloading or being prepared. Please wait.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        case .unavailable(let other):
            UnavailableView(
                icon: "exclamationmark.triangle",
                title: "Unavailable",
                message: "The model is unavailable: \(other)"
            )
        }
    }
    
    private var chatView: some View {
        VStack(spacing: 0) {
            // Title Bar
            HStack {
                Image(systemName: "apple.logo")
                    .font(.title2)
                Text("Apple Support Assistant")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray).opacity(0.1))
            
            Divider()
            
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if isLoading {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Thinking...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            .id("loading")
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) {
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isLoading) {
                    if isLoading {
                        withAnimation {
                            proxy.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Input Field
            HStack {
                TextField("Ask me anything about Apple products...", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isLoading)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .disabled(text.isEmpty || isLoading)
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !text.isEmpty else { return }
        
        let userMessage = Message(content: text, isUser: true)
        messages.append(userMessage)
        let query = text
        text = ""
        
        Task {
            isLoading = true
            let res = try? await session.respond(to: query)
            isLoading = false
            
            if let res {
                let assistantMessage = Message(content: res.content, isUser: false)
                messages.append(assistantMessage)
            } else {
                let errorMessage = Message(content: "Sorry, I couldn't process your request.", isUser: false)
                messages.append(errorMessage)
            }
        }
    }
}

struct UnavailableView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(12)
                .background(message.isUser ? Color.blue : Color(.systemGray).opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(16)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
