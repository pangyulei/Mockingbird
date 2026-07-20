---
applyTo: "**/*"
---

# Mockingbird Flutter App - AI Agent Instructions

## Project Overview
Mockingbird is a Flutter language shadowing app featuring a 3-tab navigation system: **Albums**, **Player**, and **Settings**.
It is designed for language learning through shadowing audio/video clips with synchronized subtitles.
The app follows a **Clean Architecture** influenced "Logic-State" pattern, fully integrated with **Riverpod** and **ObjectBox**.

## Architecture Summary (Riverpod Architecture)

### 1. Data Layer (ObjectBox Entities & DB Providers)
- **Entities**: Located in `lib/db/entities/`. Prefixed with `En` (e.g., `EnAlbum`, `EnMedia`, `EnSubtitle`, `EnSentence`, `EnPref`). Use `Equatable` for value comparison.
- **Logic Layer**: `DBLogic` handles direct database operations.
- **DB Providers**: Located in `lib/db/providers/`. Reactive wrappers around DB operations using `@riverpod`. 
  - Example: `dbAlbumListProvider` provides a stream/future of all albums.

### 2. UI State Management Layer (Riverpod Notifiers)
- **UI State**: Immutable classes named `{Feature}State` (e.g., `AlbumListState`).
- **UI Providers**: Use `@riverpod` Notifiers to transform DB data into specific UI states.
  - Pattern: `ref.watch(dbProvider.select(...))` is used for fine-grained reactivity.
  - Providers are responsible for UI-specific logic (e.g., finding an ID by index).

### 3. Presentation Layer (Decoupled UI Pattern)
The app strictly decouples visual rendering from side-effect heavy logic (navigation, dialogs).

- **UI Widget (`{Feature}UI`)**: 
  - Extends `ConsumerWidget`.
  - Watches providers for state.
  - Takes an interface for user actions: `final {Feature}UIOutputITF _logic`.
  - Purely visual; does not handle navigation or show dialogs directly.
- **UI Output Interface (`{Feature}UIOutputITF`)**: 
  - Abstract interface class defining user interaction callbacks (e.g., `onAddAlbum`, `onTapMedia`).
- **Screen (`{Feature}Screen`)**: 
  - Extends `ConsumerStatefulWidget`.
  - Its `State` class **implements** `{Feature}UIOutputITF`.
  - Orchestrates the `UI Widget`, passing itself as the `_logic` implementation.
  - Handles side effects: `GoRouter` navigation, `showDialog`, `SnackBar`, etc.

```
DB Provider → UI Provider → UI State
                               ↓
UI Widget (ConsumerWidget) ← Screen (Logic Implementation / Implementation of ITF)
```

## Naming & Coding Standards
- **Entities**: `En{Name}` (e.g., `EnMedia`).
- **UI State**: `{Feature}State` (e.g., `PlayerState`).
- **UI Widgets**: `{Feature}UI` (ConsumerWidget).
- **Interfaces**: `{Feature}UIOutputITF`.
- **Screens**: `{Feature}Screen` (ConsumerStatefulWidget).
- **Providers**: Defined using `riverpod_generator`. Files named `{feature}_provider.dart`.
- **Reactivity**: Prefer `ref.watch(provider.select((s) => s.relevantField))` to minimize rebuilds.

## Directory Structure
```
lib/
├── app/                    # Global UI, Theme, Routing
├── db/
│   ├── entities/           # ObjectBox @Entity classes (EnAlbum, EnMedia, etc.)
│   └── providers/          # DB-access Riverpod providers
├── tab_albums/             # Albums feature folders (album_list, album_detail, etc.)
├── tab_player/             # Player feature folders (player, sentence_card)
├── tab_settings/           # Settings feature
└── tool/                   # Parsers, formatters, and utility classes
```

## Theme & Design
- **Theme**: Premium **Dark Theme** (Telegram-inspired).
- **Palette**: Background (`#0E1621`), Surface (`#17212B`), Primary (`#5288C1`), Text Secondary (`#7F91A4`).
- **Components**: High-end visuals with custom gradients, smooth transitions, and pixel-perfect borders.

## Workflow for New Features
1. **DB Entity**: Define in `lib/db/entities/`.
2. **DB Provider**: Create reactive access in `lib/db/providers/`.
3. **UI State**: Define the immutable state in `{feature}_state.dart`.
4. **UI Provider**: Create the notifier in `{feature}_provider.dart`.
5. **Logic Interface**: Define the interaction contract in `{feature}_ui.dart`.
6. **UI Widget**: Implement the visual layout in `{feature}_ui.dart`.
7. **Screen**: Implement the interface and build the UI in `{feature}_screen.dart`.
8. **Route**: Register in `app_ui.dart`.
