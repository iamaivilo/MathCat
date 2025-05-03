# MathCat

A playful math learning app for kids, featuring cat-themed lessons and quizzes for grades K-8.

## Features

- 📚 Grade-appropriate math lessons (K-8)
- 🐱 Cat-themed content to keep kids engaged
- 📝 Multiple-choice questions with instant feedback
- 🎯 Final quiz with score tracking
- 🏆 Progress tracking with dynamic star ratings (scaled to quiz length)
- 🎨 Customizable avatar and grade selection
- 📱 iOS 17+ support
- 🎉 Confetti animations for achievements

## Requirements

- Xcode 15 or later
- iOS 17.0 or later
- Swift 5.9 or later

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/MathCat.git
```

2. Open the project in Xcode:
```bash
cd MathCat
open MathCat.xcodeproj
```

3. Select your target device (iPhone or iPad) and click the Run button (⌘R)

## Project Structure

```
MathCat/
├── Model/
│   ├── Grade.swift
│   ├── LessonItem.swift
│   └── QuizResult.swift
├── Data/
│   └── lessons.json
├── ViewModel/
│   ├── UserProfileVM.swift
│   └── LessonVM.swift
├── Views/
│   ├── OnboardingView.swift
│   ├── TabRootView.swift
│   ├── Lesson/
│   │   ├── LessonCardView.swift
│   │   ├── QuestionView.swift
│   │   └── QuizView.swift
│   └── Profile/
│       ├── ProfileView.swift
│       ├── EmojiPickerSheet.swift
│       └── GradePickerSheet.swift
└── Resources/
    └── AppColors.xcassets
```

## Usage

1. Launch the app and complete the onboarding process
2. Select your grade level
3. Read through the lesson content
4. Answer practice questions
5. Take the final quiz
6. Track your progress in the Profile tab (star ratings scale to quiz length for fairness)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 