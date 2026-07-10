---
applyTo: "**/*"
---

# Mockingbird Flutter App - AI Agent Instructions

## Project Overview
Mockingbird is a Flutter language shadowing app featuring a 3-tab navigation system: **Albums**, **Player**, and **Settings**.
It is designed for language learning through shadowing audio/video clips with synchronized subtitles.
The app follows a **Clean Architecture** influenced "Logic-State" pattern, now fully integrated with **Riverpod** for state management and **ObjectBox** for persistence.

## Architecture Summary

### State Management Pattern (Riverpod + UI Interface)
The app uses Riverpod (with `riverpod_generator`) to manage state, while maintaining a decoupled UI via interfaces.

```
UI (ConsumerWidget) → Interface (UIOutputITF) → Screen (Logic Implementation)
         ↓
State (Riverpod Providers)
```

**Key Components:**
- **UI State**: Immutable classes named `{Feature}State` with `copyWith()` methods.
- **Providers**: Use `@riverpod` (Async)Notifiers to handle UI business logic and state updates.
- **UI Output Interface**: Defined as `abstract interface class {Feature}UIOutputITF`. This decouples the visual UI from side-effect heavy logic (like navigation or dialogs).
- **UI Widget**: A `ConsumerWidget` named `{Feature}UI` that watches providers for state and takes an interface for actions.
- **Screen**: A `ConsumerStatefulWidget` named `{Feature}Screen` whose `State` class implements `{Feature}UIOutputITF`. It handles navigation and builds the UI widget.

### Data Layer (ObjectBox & DB Providers)
- **Entities**: Managed in `lib/db/entities/` (Album, Media, Subtitle, Sentence).
- **Logic Layer**: `DBLogic` (in `lib/db/db_logic.dart`) handles direct database operations.
- **DB Providers**: Riverpod providers (e.g., `dbAlbumsAsyncProvider`) wrap `DBLogic` to provide reactive access to the database across the app.
- **Relationships**:
  - `Album` ↔ `Media` (Many-to-Many).
  - `Media` → `Subtitle` (One-to-One).
  - `Subtitle` → `Sentence` (One-to-Many).

### Navigation
- **Router**: Managed via `go_router`.
- **Tabs**: `StatefulShellRoute.indexedStack` manages Albums, Player, and Settings.
- **Theme**: Premium **Dark Theme** (Telegram-inspired) with deep navy (`#0E1621`) and surface blue (`#17212B`) palette.

## File Structure Conventions

### Directory Structure
```
lib/
├── app/                    # Routing, Global UI, and Theme
├── db/                     # Entities, direct DB logic, and DB providers
├── model/                  # Legacy/Helper models
├── tab_albums/             # Albums feature (Grid, Detail, Edit)
├── tab_player/             # Player feature (Playback logic, Shadowing tracking)
├── tab_settings/           # Settings feature
└── main.dart              # Entry point with ProviderScope
```

### Naming & Coding Standards
- **Providers**: Defined in `{feature}_provider.dart`. Use `riverpod_generator`.
- **UI Widgets**: Named `{Feature}UI`. Always extend `ConsumerWidget`.
- **Logic Interfaces**: Named `{Feature}UIOutputITF`.
- **Screens**: Named `{Feature}Screen`. Orchestrates the UI and navigation.
- **State**: Always immutable. Use `AsyncValue` for data that might be loading or have errors.

## Workflow for New Features
1. **DB**: Define entities in `lib/db/entities/` and DB logic in `lib/db/db_logic.dart`.
2. **DB Provider**: Create a Riverpod provider in `lib/db/providers/` to expose the data.
3. **UI State**: Define the immutable state in `{feature}_state.dart`.
4. **UI Provider**: Create a provider in the feature folder that transforms DB data into UI state.
5. **Interface**: Define the user interaction contract in `{feature}_ui.dart` as an interface.
6. **UI**: Implement the visual layout in `{feature}_ui.dart` as a `ConsumerWidget`.
7. **Screen**: Create the `{feature}_screen.dart` to implement the interface and build the UI.
8. **Route**: Register the new screen in `app_ui.dart` and `app_route.dart`.
