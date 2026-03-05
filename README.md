# TO DO LIST for macOS (SwiftUI)

Minimal, fast to‑do app for macOS built with SwiftUI. Add, complete, and delete tasks with local JSON persistence. Clean, Notes‑like look and feel.

## Features
- Add tasks with priority: low, medium, high
- Complete/uncomplete tasks (strikethrough and subtle grayscale for completed)
- Delete tasks
- Counter: “N tasks remaining”
- Local JSON persistence at `~/Documents/ToDoApp/tasks.json`
- Filters: All, Active, Completed
- Sorting: by Date (created), Priority, or Status

## Requirements
- macOS 12.0 or newer (project is configured for 12.0)
- Xcode 14+ (Swift, SwiftUI)
- No third‑party dependencies

## Project Structure
```
ToDoAppSwiftUI.xcodeproj
ToDoAppSwiftUI/
├─ Models/
│  └─ Task.swift                // Priority enum, TaskItem model (Codable, Identifiable)
├─ Services/
│  └─ TaskStorage.swift         // JSON read/write to ~/Documents/ToDoApp/tasks.json
├─ ViewModels/
│  └─ TaskViewModel.swift       // add/toggle/delete, autosave, filters, sorting
├─ Views/
│  ├─ ContentView.swift         // header, input, filters/sorting controls, list, footer counter
│  └─ TaskRowView.swift         // row with checkbox, title, priority pill, Delete
└─ ToDoAppSwiftUIApp.swift      // SwiftUI app entry point
```

### Architecture
- MVVM + Service
  - Model: `TaskItem` and `Priority` describe task data.
  - Service: `TaskStorage` handles JSON persistence with atomic writes. If the file does not exist, an empty list is assumed.
  - ViewModel: `TaskViewModel` exposes task list and operations, and persists automatically on changes.
  - Views: `ContentView` and `TaskRowView` render the interface in a clean, Notes‑like style.

## Build & Run
1) Open the project:
```bash
cd "/Users/jakub/Documents/To do list"
open ToDoAppSwiftUI.xcodeproj
```
2) In Xcode:
- Select the “ToDoAppSwiftUI” scheme and target “My Mac”
- Set Signing Team if prompted (Signing & Capabilities)
- Run: Cmd + R

## Usage
- Type a task title, choose a priority, and click “Add” (or press Return)
- Click the square to toggle completion (completed tasks are strikethrough and gray)
- Click “Delete” to remove a task
- Use the segmented controls to filter and sort the list
- All changes are saved immediately to JSON

## Data Format
File: `~/Documents/ToDoApp/tasks.json`
```json
{
  "id": "UUID",
  "title": "Buy milk",
  "isCompleted": false,
  "priority": "medium",
  "createdDate": "2026-03-05"
}
```
