# MathCat App Summary

## Overview
MathCat is an educational iOS app built with SwiftUI that provides math lessons, practice questions, and quizzes for children in grades K-8. The app features a cat theme throughout the content and user interface.

## Core Features
- Grade-specific math content from Kindergarten through 8th grade
- Interactive lessons with engaging markdown content
- Practice questions after each lesson
- Quizzes to test understanding
- Profile tracking with score/star ratings
- Onboarding experience for new users
- Mini-games with reward system and virtual economy

## App Structure
The app is organized into three main tabs:
1. **Lesson Tab**: Displays grade-appropriate lessons with practice questions and quizzes
2. **Game Tab**: Contains mini-games that reinforce math skills and reward with treats
3. **Profile Tab**: Shows user information, progress, and settings

## Data Structure
The app is primarily driven by two structured JSON data files:

### lessons.json Structure
```json
[
  {
    "grade": 0,                      // Grade level (0=K, 1=1st, etc.)
    "topic": "Counting Cats",        // Lesson title
    "lessonMarkdown": "# Counting...",  // Lesson content with markdown
    "mcq": [                         // Practice questions
      {
        "q": "How many cats are here?",  // Question text
        "choices": ["1", "2", "3", "4"], // Answer choices
        "answer": 2                      // Index of correct answer (0-based)
      },
      // More practice questions...
    ],
    "quizBank": [                    // Quiz questions
      // Same structure as mcq but used for final quizzes
    ]
  },
  // More lessons...
]
```

### games.json Structure
```json
{
  "catTreat": {
    "questions": [
      {
        "q": "What is 2 + 3?",
        "choices": ["4", "5", "6", "7"],
        "answer": 1
      },
      // More questions...
    ]
  },
  "catGrooming": {
    "questions": [
      {
        "q": "What is 12 × 3?",
        "choices": ["34", "36", "38", "40"],
        "answer": 1
      },
      // More questions...
    ]
  }
}
```

## Lesson Content Format
Each lesson has a consistent structure:

1. **Title with Emoji**: `# Counting Cats! 🐾`
2. **Instructional Content**: Written in friendly, cat-themed language
3. **Key Concepts**: Often in bullet points with:
   - **Bold** for important terms
   - _Italics_ for emphasis
   - `Code formatting` for numbers and equations
4. **Tips**: Highlighted as `> **Meowtip:** text...`
5. **Closing**: Usually a call to action like "**Ready to practice?**"

## Content Progression
The app follows a standard math curriculum across grades:

- **Kindergarten (Grade 0)**: Counting, shapes, comparing, patterns, colors
- **1st Grade (Grade 1)**: Addition/subtraction, place value, word problems, skip counting, time
- **2nd Grade (Grade 2)**: Two-digit operations, multiplication intro
- **Higher Grades**: More advanced concepts with age-appropriate explanations

## Learning Flow
1. User selects a grade level
2. Available lessons are displayed (locked/unlocked based on progress)
3. User selects a lesson to read the material
4. After reading, user takes practice questions
5. After completing practice, a final quiz is available
6. Performance on quizzes affects star ratings in profile

## Game Features
The app includes three game components:

1. **Cat Treat Game**:
   - 10 math questions to answer in 2 minutes
   - Each correct answer earns 1 treat
   - Questions are simpler but time-constrained

2. **Cat Grooming Game**:
   - 5 harder math questions in 1 minute
   - Each correct answer earns 2 treats
   - Perfect score earns 20 bonus treats

3. **Cat House Store**:
   - Allows users to spend earned treats on profile icons
   - Creates a virtual economy/reward system
   - Encourages continued engagement

Games have a daily play limit to encourage regular but measured usage.

## Key Models
- **Grade**: Enum representing grade levels K-8
- **LessonItem**: Represents a lesson with topic, content, practice questions, and quiz
- **QuizResult**: Tracks user performance on quizzes
- **GameQuestions**: Contains questions for the mini-games

## Technical Implementation
- **SwiftUI**: Used for all UI components
- **MVVM Architecture**: Clear separation between views and data
- **AppStorage**: Persistent storage for user data and progress
- **Markdown Rendering**: Dynamic content display with formatting
- **JSON Data Source**: Easily updatable content structure

## API Requirements for Backend
To create a backend API for this app, you would need endpoints that:

1. Provide access to lesson content by grade
2. Serve practice questions and quiz questions
3. Store and retrieve user progress and quiz results
4. Authenticate users (if implementing multi-user support)
5. Deliver game questions and track rewards/purchases

Specific API endpoints might include:
- `GET /lessons?grade={gradeLevel}`
- `GET /lesson/{lessonId}`
- `GET /quiz/{lessonId}`
- `POST /results` (to store quiz results)
- `GET /user/{userId}/progress`
- `GET /games/{gameType}/questions`
- `POST /user/{userId}/treats` (update treat count)
- `GET /store/items`
- `POST /user/{userId}/purchases`

## Content Approach
The app uses a friendly, engaging tone with cat-themed content to make math learning fun:
- Each lesson incorporates cat examples and metaphors
- Questions are phrased in an age-appropriate way for each grade
- Content progression follows standard math curriculum from K-8
- Emoji and formatting enhance engagement
- Game mechanics reinforce learning with rewards

This summary provides the essential context needed to understand the MathCat app's structure and data requirements for creating a complementary backend API service. 