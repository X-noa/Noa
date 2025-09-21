# Developer Note: AI Integration

This document outlines where a real AI backend would be integrated into the Noa application.

## Chat Interface (`lib/screens/chat_screen.dart`)

The `ChatScreen` widget currently uses a mock service to generate responses from Noa. To integrate a real AI, the `_handleSubmitted` method would be modified to make a network request to an AI backend instead of using the mock `Future.delayed`.

The backend would receive the user's message and return a response, which would then be added to the chat history. The response from the backend should be in the same JSON format as the `chat_responses.json` file, with a `text` field for the message and an optional `symptom_flag` field for the safety modal.

## Safety Modal (`lib/services/mock_rules_engine.dart`)

The `MockRulesEngine` is currently a simple class that checks for the presence of symptom flags in the chat history. A real implementation would likely involve a more sophisticated rules engine or a call to a separate AI model that specializes in sentiment analysis and risk detection.

The backend would be responsible for analyzing the user's messages and returning the appropriate `symptom_flag`s. The client-side rules engine would then use these flags to determine if the safety modal should be shown.

## Recommended Activities (`lib/screens/home_screen.dart`)

The `HomeScreen` currently shows a hardcoded list of recommended activities. A real AI implementation would involve a recommendation engine that suggests activities based on the user's mood history, journal entries, and other data.

The backend would provide an endpoint that returns a list of recommended activities for the user, which would then be displayed in the `ActivityCarousel`.
