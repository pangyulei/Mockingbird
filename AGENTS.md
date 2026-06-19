---
applyTo: "**/*"
---

# Mockingbird Flutter App - AI Agent Instructions

## Project Overview
Mockingbird is a Flutter language shadowing app with a 3-tab bottom navigation system.
It's designed for learning languages by shadowing audio/video clips with subtitles, sentence by sentence.
Playlists can contain both audio and video clips mixed together.
The app uses ObjectBox database for persistence and follows a custom, framework-independent state management pattern.

## Architecture Summary

### State Management Pattern (Logic-State)
The app uses a custom unidirectional data flow:
```
Widget (UI) → Logic (implements InterfaceUIEvents) → State (immutable)
                                ↓
                        setState() via Stream subscription 
```

**Key Rules:**
- **Async operations**: Return `Stream<State>` and yield multiple states (loading → loaded).
- **Sync operations**: Return `State` directly.
- **InterfaceUIEvents**: Abstract classes defining feature capabilities.
- **Logic**: Classes implementing business logic and state transitions.
- **State**: Immutable classes with `copyWith()` factory methods.

### Database Layer (ObjectBox)
- **Setup**: Singleton `ObjectBox` class (in `lib/db/objectbox.dart`) manages the Store.
- **Repositories**: `DBPlaylist` and `DBMedia` handle data persistence.
- **Relationships**:
  - `Playlist` has a `ToMany<Media>` relationship named `medias`.
  - `Media` has a `ToOne<Playlist>` relationship named `playlist`.
  - Use `@Backlink('playlist')` on `Playlist.medias` for automatic synchronization.
- **Constructor Rule**: Entity constructors should favor optional relationship parameters (`Playlist? playlist`) to allow ObjectBox to instantiate them before relationships are fully resolved.

### Navigation and Tab Management
- **Main Shell**: `AppWidget` manages the bottom navigation using an `IndexedStack`.
- **Tab Switching**: Handled by dispatching a Flutter `Notification` (e.g., `NotificationPlayMedia`) which is caught by a `NotificationListener` in `AppWidget`.
- **Nested Navigation**: Each tab uses its own `Navigator` (e.g., `PlaylistsNavWidget`, `PlayerNavWidget`).

## File Structure Conventions

### Directory Structure
```
lib/
├── app/                    # Root app components (Shell, Logic, State)
├── db/                     # Database repositories and ObjectBox setup
├── models/                 # ObjectBox Entities (Playlist, Media)
├── notifications/          # Global Flutter Notifications (e.g., NotificationPlayMedia)
├── tab_playlists/          # Playlists Feature (Grid, Detail, Nav)
│   ├── playlists_nav/      # Tab-specific Navigator
│   ├── playlists_grid/     # Main grid view
│   └── playlist_detail/    # Detail view logic/state/UI
├── tab_player/             # Player Feature
│   └── player_nav/         # Tab-specific Navigator
└── main.dart              # App entry point
```

### Naming Conventions
- **Interfaces**: `{Feature}InterfaceUIEvents`
- **Logic**: `{Feature}Logic`
- **States**: `{Feature}State`
- **Widgets**: `{Feature}Widget`
- **Database**: `DB{Feature}`

## Coding Standards

### Logic & Interface Pattern
```dart
abstract interface class FeatureInterfaceUIEvents {
  Stream<FeatureState> initState();
  void doAction();
}

class FeatureLogic implements FeatureInterfaceUIEvents {
  final _notificationController = StreamController<Object>.broadcast();
  Stream<Object> get notifications => _notificationController.stream;

  @override
  Stream<FeatureState> initState() async* {
    yield const FeatureState(loading: true);
    // ... logic
    yield FeatureState(loading: false, data: result);
  }
}
```

### Notification Pattern for Tab Communication
To trigger cross-tab actions (like playing a media and switching to the player):
1. **Logic** pushes a Notification object into a broadcast stream.
2. **Widget** listens to the stream and calls `notification.dispatch(context)`.
3. **AppWidget** catches it with `NotificationListener` and updates the global `AppState`.

### Media Handling
- **Original Paths**: Always store the original file paths (`pathStr`, `subPathStr`).
- **Auto-Subtitle**: Match `.srt`, `.vtt`, `.sub`, `.ass` files to media by filename.
- **Centralized Extensions**: Use `TrackType` static constants in `lib/models/track.dart`.

### State Updates
- Use `copyWith()` for state updates.
- **Shadow Copy Only**: All `copyWith()` methods must perform shadow copies of references. 
- **Container Rule**: For collections (e.g., `List`, `Map`), the implementation must be `list: list ?? this.list` (referencing the same instance), NOT `list: list ?? [...this.list]` (which creates a new instance).
- **Manual Deep Copy**: If a deep copy is needed for a specific update, the caller is responsible for passing a new collection instance: `state.copyWith(list: List.from(oldList))`.

## Workflow
1. Define the contract in `*InterfaceUIEvents`.
2. Implement business logic in `*Logic`.
3. Handle UI state in `*State`.
4. Connect them in `*Widget` using `initState()` and `setState()`.
5. Use `Notification` system for high-level app navigation.

This architecture ensures a clean separation between UI, business logic, and persistence.
