# FMTest

A SwiftUI application demonstrating Apple's FoundationModels framework.

## Overview

FMTest is a sample iOS app that showcases Apple Intelligence features using the FoundationModels framework. The app implements a conversational AI assistant specifically trained to help users with Apple product-related questions.

## Features

- **Real-time Chat Interface**: Clean, intuitive messaging UI with user and assistant message bubbles
- **Model Availability Detection**: Automatic handling of various device states:
  - Device eligibility checking
  - Apple Intelligence enablement status
  - Model readiness and download progress
- **Async Processing**: Non-blocking message handling with loading indicators

## Requirements

- iOS 18.2+ (for FoundationModels framework)
- Xcode 16.0+
- Swift 6.0+
- Device with Apple Intelligence support
- Apple Intelligence enabled in Settings

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd FMTest
```

2. Open the project in Xcode:
```bash
open FMTest.xcodeproj
```

3. Build and run the project on a compatible device

## Usage

1. Ensure Apple Intelligence is enabled on your device (Settings → Apple Intelligence & Siri)
2. Launch the app
3. Type your Apple product-related question in the text field
4. Tap the send button or press return to submit
5. The assistant will respond with helpful information

## Project Structure

```
FMTest/
├── FMTestApp.swift         # App entry point
├── ContentView.swift       # Main chat interface and logic
└── Assets.xcassets/        # App assets
```

## Key Components

### LanguageModelSession
Manages the conversational context with custom instructions for the Apple Support Assistant role.

### Model Availability Handling
The app gracefully handles different states:
- Available: Shows the chat interface
- Device Not Eligible: Displays appropriate message
- Apple Intelligence Not Enabled: Prompts user to enable
- Model Not Ready: Shows download/preparation progress
- Other errors: Generic error handling

## License

Copyright © 2026 Chenluo Deng

## Acknowledgments

Built with Apple's FoundationModels framework and SwiftUI.
