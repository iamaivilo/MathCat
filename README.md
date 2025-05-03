# MathCat - Fun Math Learning for Kids

A playful, kid-friendly iOS app that makes learning math fun! Built with SwiftUI.

## Features

- **Interactive Lessons**: Grade-appropriate math lessons with engaging content
- **Practice & Quizzes**: Test knowledge with practice questions and final quizzes
- **Progress Tracking**: Track progress with star ratings for each grade
- **Fun Games**:
  - Cat Treat: 10 questions in 2 minutes, earn treats
  - Cat Grooming: 5 harder questions in 1 minute, earn double treats
  - Cat House: Shop to buy fun icons with earned treats
- **Daily Play Limits**: Games can be played once per day
- **Profile Customization**: Choose avatar and grade level
- **Testing Tools**: Reset buttons for progress and games

## Project Structure

```
Mathcat not Dad/
├── Data/
│   ├── lessons.json      # Lesson content for each grade
│   └── games.json        # Game questions for Cat Treat and Cat Grooming
├── Model/
│   ├── Grade.swift       # Grade enum and related types
│   ├── LessonItem.swift  # Lesson and question models
│   └── GameQuestions.swift # Game questions model
├── ViewModel/
│   ├── UserProfileVM.swift  # User data and game state management
│   └── LessonVM.swift    # Lesson and quiz logic
├── Views/
│   ├── OnboardingView.swift
│   ├── TabRootView.swift
│   ├── Lesson/
│   │   ├── LessonTabView.swift
│   │   └── QuizView.swift
│   ├── Game/
│   │   ├── GameTabView.swift
│   │   ├── CatTreatGameView.swift
│   │   ├── CatGroomingGameView.swift
│   │   └── CatHouseView.swift
│   └── Profile/
│       ├── ProfileTabView.swift
│       ├── EmojiPickerSheet.swift
│       └── GradePickerSheet.swift
└── Mathcat not DadApp.swift
```

## Data Structure

### Lessons (lessons.json)
```json
{
  "grade": 0,
  "topic": "Addition",
  "lessonMarkdown": "...",
  "mcq": [
    {
      "q": "What is 2 + 3?",
      "choices": ["4", "5", "6", "7"],
      "answer": 1
    }
  ],
  "quizBank": [...]
}
```

### Games (games.json)
```json
{
  "catTreat": {
    "questions": [
      {
        "q": "What is 2 + 3?",
        "choices": ["4", "5", "6", "7"],
        "answer": 1
      }
    ]
  },
  "catGrooming": {
    "questions": [
      {
        "q": "What is 12 × 3?",
        "choices": ["34", "36", "38", "40"],
        "answer": 1
      }
    ]
  }
}
```

## Development Notes

- **Testing Tools**:
  - Reset Progress: Clears lesson progress and star ratings
  - Reset Games: Clears treats, purchased items, and daily game limit
  - Both buttons available in Profile tab

- **Game Mechanics**:
  - Cat Treat: 10 questions, 2 minutes, 1 treat per correct answer
  - Cat Grooming: 5 harder questions, 1 minute, 2 treats per correct answer
  - Cat House: Shop to buy icons with treats
  - Daily play limit: One game per day

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
2. Open `Mathcat not Dad.xcodeproj` in Xcode
3. Build and run on simulator or device

## License

This project is licensed under the MIT License - see the LICENSE file for details. 