---
applyTo: "**/*"
---

# Mockingbird Flutter App - AI Agent Instructions

## Project Overview
Mockingbird is a Flutter language shadowing app with a 3-tab bottom navigation system (Albums, Player, Settings).
It's designed for learning languages by shadowing audio/video clips with subtitles, sentence by sentence.
Albums contain media clips (audio/video), which have associated subtitles and sentences.
The app uses ObjectBox database for persistence and follows a custom "Logic-State" architecture.

## Architecture Summary

### State Management Pattern (Logic-State)
The app uses a specific pattern where Logic is typically encapsulated in a `StatefulWidget`'s `State` class, which implements a UI Output interface.
```
Widget (UI) → Screen (Logic - implements UIOutputITF) → State (immutable)
                                ↓
                        setState() after state updates
```

**Key Rules:**
- **UI Output Interface**: Defined as `abstract interface class {Feature}UIOutputITF`.
- **UI Widget**: A `StatelessWidget` named `{Feature}UI` that takes the state and the logic interface as parameters.
- **Screen**: A `StatefulWidget` named `{Feature}Screen` whose `State` class implements `{Feature}UIOutputITF`.
- **State**: An immutable class named `{Feature}State` with `copyWith()` methods for updates.
- **Async operations**: Handle async work in the Screen's State class, typically updating the immutable state and calling `setState()`.

### Database Layer (ObjectBox)
- **Setup**: Singleton `DBObjectBox` class (in `lib/db/db_objectbox.dart`) manages the Store.
- **Repositories**: `DBAlbum` and `DBMedia` handle complex data persistence and operations.
- **Entities**:
  - `Album`: Has `name`, `cover`, `sortOrder`, and a `@Backlink('albums')` relationship `medias` (`ToMany<Media>`).
  - `Media`: Has `path`, `name`, and a `ToMany<Album>` relationship `albums`.
  - `Subtitle`: Has a `ToOne<Media>` and a `@Backlink('subtitle')` relationship `sentences` (`ToMany<Sentence>`).
  - `Sentence`: Has `startMicroseconds`, `endMicroseconds`, `text`, and a `ToOne<Subtitle>`.
- **Relationships**: `Album` and `Media` have a Many-to-Many relationship.
- **Cascading Deletes**: Handled manually in repositories (e.g., `DBAlbum.removeMany` deletes orphaned media, subtitles, and sentences).

### Navigation
- **Router**: Uses `go_router` package.
- **Shell**: `StatefulShellRoute.indexedStack` manages the 3 main tabs.
- **Routes**: Defined in `AppUI._goRouter()` using `AppRoute` constants.
- **Tabs**:
  1. **Albums**: `/albums` (List and Detail views)
  2. **Player**: `/player` (Media playback and shadowing)
  3. **Settings**: `/settings` (App configuration)

## File Structure Conventions

### Directory Structure
```
lib/
├── app/                    # Global app shell, routing, and UI entry point
├── db/                     # Database repositories and ObjectBox setup
├── model/                  # ObjectBox Entities (Album, Media, Subtitle, Sentence)
├── tab_albums/             # Albums Feature (Grid, Detail, Edit)
├── tab_player/             # Player Feature (Playback logic, Sentence tracking)
├── tab_settings/           # Settings Feature
└── main.dart              # App entry point
```

### Naming Conventions
- **Interfaces**: `{Feature}UIOutputITF`
- **Screens**: `{Feature}Screen`
- **UI Components**: `{Feature}UI`
- **States**: `{Feature}State`
- **Database**: `DB{Feature}`

## Coding Standards

### Logic & UI Pattern Example
```dart
abstract interface class FeatureUIOutputITF {
  void onAction();
}

class FeatureScreen extends StatefulWidget { ... }

class _FeatureScreenState extends State<FeatureScreen> implements FeatureUIOutputITF {
  var _state = const FeatureState();

  @override
  void onAction() {
    setState(() {
      _state = _state.copyWith(...);
    });
  }

  @override
  Widget build(BuildContext context) => FeatureUI(_state, this);
}
```

### Media Handling
- **File Paths**: `Media` stores the full path to the media file.
- **Types**: `MediaType` (audio/video) is derived from file extension using `MediaType.fromExtension`.
- **Subtitles**: Linked to `Media`. Currently supports `.srt` and `.vtt`.

### State Updates
- Use `copyWith()` for all state updates.
- **Shadow Copy**: `copyWith()` performs shadow copies. Collections are passed by reference unless explicitly copied by the caller.
- **Optional Updates**: Use `Function?` or similar patterns in `copyWith` for fields that can be set to null.

## Workflow
1. Define entities in `lib/model/` and run `build_runner`.
2. Define the UI contract in `{Feature}UIOutputITF`.
3. Create the immutable `{Feature}State`.
4. Implement the UI in a `StatelessWidget` named `{Feature}UI`.
5. Connect everything in `{Feature}Screen` and its `State` class.
6. Register new routes in `app_ui.dart` and `app_route.dart`.
