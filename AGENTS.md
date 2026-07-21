---
applyTo: "**/*"
---

# Mockingbird Flutter App - AI Agent Instructions

## Project Overview
Mockingbird is a Flutter language shadowing app featuring a 3-tab navigation system: **Albums**, **Player**, and **Settings**.
It is designed for language learning through shadowing audio/video clips with synchronized subtitles.
The app follows a strict **Logic-State** pattern integrated with **Riverpod** and **ObjectBox**.

## Architecture Summary (Riverpod Architecture)

### 1. Data Layer (Persistence & Global State)
- **Entities**: Located in `lib/db/entities/`. Prefixed with `En` (e.g., `EnAlbum`, `EnMedia`). Use `Equatable` for comparison.
- **Logic Layer**: `DBLogic` (in `lib/db/db_logic.dart`) handles direct database operations.
- **DB Providers**: Located in `lib/db/providers/`. Reactive wrappers around DB operations.
  - They maintain the "Source of Truth" in memory.
  - They depend on `DBLogic` for disk I/O and update their own state to notify listeners.

### 2. UI State Management Layer (Business Logic)
- **UI State**: Immutable classes named `{Feature}State` (e.g., `AlbumListState`).
- **UI Providers**: Riverpod Notifiers (usually in `{feature}_provider.dart`).
  - **Responsibilities**: Contain all business logic. They do NOT need a separate "Screen" or "Controller" class.
  - **Dependencies**: They `ref.watch` or `ref.read` **DB Providers** to access data and perform actions.
  - **Transformation**: They transform complex DB data into simplified, flat state objects suitable for the UI.

### 3. Presentation Layer (Unified UI Component)
- **UI Component (`{Feature}UI`)**: 
  - Extends `ConsumerWidget`.
  - **Role**: Purely responsible for rendering visuals and **passing user events** to the UI Provider.
  - **Reactivity**: Uses `ref.watch(uiProvider.select((s) => s.relevantField))` to rebuild only when necessary.
  - **No Logic**: Does not contain business logic. Event handlers (e.g., `onTap`) should call methods on the UI Provider's notifier (e.g., `ref.read(uiProvider.notifier).handleTap()`).
  - **Side Effects**: UI-specific side effects (navigation, `showDialog`, `SnackBar`) are triggered within these event handlers in the UI component.

```
DB Provider (Global State) 
    ^
    | (ref.watch / ref.read)
    |
UI Provider (UI Logic & Transformation) 
    ^
    | (ref.read(notifier).doSomething())
    |
UI Component (Visual Rendering & Event Dispatching)
```

## Naming & Coding Standards
- **Entities**: `En{Name}` (e.g., `EnMedia`).
- **UI State**: `{Feature}State` (e.g., `PlayerState`).
- **UI Components**: `{Feature}UI` (ConsumerWidget).
- **Providers**: Defined using `riverpod_generator`. Files named `{feature}_provider.dart`.
- **Logic**: All non-visual logic belongs in the `UI Provider`.

## Directory Structure
```
lib/
├── app/                    # Global UI, Theme, Routing
├── db/
│   ├── entities/           # ObjectBox @Entity classes (EnAlbum, EnMedia, etc.)
│   └── providers/          # DB-access Riverpod providers
├── tab_albums/             # Albums feature folders
├── tab_player/             # Player feature folders
├── tab_settings/           # Settings feature
└── tool/                   # Utility classes (Parsers, etc.)
```

## Workflow for New Features
1. **DB**: Define `EnEntity` and add methods to `DBLogic`.
2. **DB Provider**: Create a provider in `lib/db/providers/` to expose the data.
3. **UI State**: Define the immutable state in `{feature}_state.dart`.
4. **UI Provider**: Create the notifier in `{feature}_provider.dart` to manage logic and state.
5. **UI Component**: Implement visuals in `{feature}_ui.dart` and connect interactions to the provider.
6. **Route**: Register in `app_route.dart`.
