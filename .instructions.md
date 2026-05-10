# Mockingbird Flutter App - AI Agent Instructions

## Project Overview
Mockingbird is a Flutter language shadowing app with a 3-tab bottom navigation system.
It's designed for learning languages by shadowing audio/video clips with subtitles, sentence by sentence.
Playlists can contain both audio and video clips mixed together for comprehensive language practice.
The app uses ObjectBox database for persistence and follows a custom, framework-independent state management pattern.

## Architecture Summary

### State Management Pattern
The app uses a custom event-handler pattern:
```
Widget (UI) → Handler (implements Events interface) → State (immutable)
                                ↓
                        setState() via Stream subscription 
```

**Key Rules:**
- **Async operations** return `Stream<State>` and can yield multiple states (loading → loaded)
- **Sync operations** return `State` directly
- **Events interfaces** define widget capabilities (e.g., `PlaylistsListEvents`)
- **Handlers** implement business logic
- **State classes** are immutable with `copyWith()` factory methods

### Database Layer: ObjectBox with Media Items
- **Setup**: Singleton `DB` class manages ObjectBox Store
- **Repositories**: `DBPlaylist` and `DBTrack` for playlist and media operations
- **Operations**: All async operations for data persistence
- **File handling**: Smart lifecycle management, no media file duplication

**Playlist Entity**: Basic playlist info (name, cover, sortOrder)
**Track Entity**: Individual media files with metadata
- Fields: `filePath`, `subtitlePath`, `mediaType`, `durationMs`, `sortOrder`
- **fileName**: Computed getter from `filePath` (not stored)
- **MediaType enum**: `audio` or `video` (can be mixed in same playlist)
- **Subtitle auto-detection**: Automatically finds .srt, .vtt, .sub, .ass files with same name
- **No file copying**: Stores original file paths, doesn't duplicate media files
- **One-way relation**: Tracks belong to playlists but don't store playlistId

### Widget Organization
3-tier hierarchy:
```
AppWidget (root)
  └── TabPlaylistsWidget (nested navigator)
      ├── PlaylistsListWidget (grid + multi-select)
      └── PlaylistWidget (detail view)
```

### Event Handling Architecture
Each feature follows:
```
feature_widget.dart (UI, calls handler methods)
feature_handler.dart (implements events interface)
feature_events.dart (abstract interface — contract)
feature_state.dart (immutable state with copyWith)
```

## File Structure Conventions

### Directory Structure
```
lib/
├── app/                    # Root app components
│   ├── app_widget.dart     # Bottom navigation
│   ├── app_handler.dart    # App-level events
│   ├── app_events.dart     # App event contracts
│   └── app_state.dart      # App state
├── db/                     # Database layer
│   ├── db.dart            # ObjectBox setup
│   ├── db_playlist.dart   # Playlist repository
│   └── db_track.dart      # Track repository
├── models/                 # Data models
│   ├── playlist.dart      # Playlist entity
│   └── track.dart         # Track entity
├── tab_playlists/          # Playlists feature
│   ├── tab_playlists/      # Tab container
│   ├── playlists_list/     # List view
│   ├── playlist/           # Detail view
│   └── playlist_create/    # Create modal
└── main.dart              # App entry point
```

### Naming Conventions
- **Events**: `{Feature}Events` (interface)
- **Handlers**: `{Feature}Handler` (implementation)
- **States**: `{Feature}State` (immutable data)
- **Widgets**: `{Feature}Widget` (UI component)
- **Database**: `DB{Feature}` (repository)

## Coding Standards

### State Classes
```dart
class PlaylistState {
  final Playlist? playlist;
  final bool showLoading;

  const PlaylistState({this.playlist, this.showLoading = true});

  PlaylistState copyWith({Playlist? playlist, bool? showLoading}) {
    return PlaylistState(
      playlist: playlist ?? this.playlist,
      showLoading: showLoading ?? this.showLoading,
    );
  }
}
```

### Handler Implementation
```dart
class PlaylistHandler implements PlaylistEvents {
  const PlaylistHandler();

  @override
  Stream<PlaylistState> playlistWidgetInitState(int playlistId) async* {
    yield const PlaylistState(showLoading: true);
    final playlist = await DBPlaylist(DB.instance.store).getByIdAsync(playlistId);
    yield PlaylistState(playlist: playlist, showLoading: false);
  }
}
```

### Widget Pattern
```dart
class PlaylistWidget extends StatefulWidget {
  final int _playlistId;
  final PlaylistEvents _handler;

  const PlaylistWidget(this._playlistId, this._handler, {super.key});

  @override
  State<PlaylistWidget> createState() => _PlaylistWidgetFactory();
}

class _PlaylistWidgetFactory extends State<PlaylistWidget> {
  PlaylistState _state = const PlaylistState();

  @override
  void initState() {
    super.initState();
    _updateStateByStream(
      widget._handler.playlistWidgetInitState(widget._playlistId),
    );
  }

  Future<void> _updateStateByStream(Stream<PlaylistState> stream) async {
    await for (final newState in stream) {
      _updateState(newState);
    }
  }

  void _updateState(PlaylistState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build UI based on _state
  }
}
```

## Common Operations

### Adding a New Feature
1. Create `feature_events.dart` (interface)
2. Create `feature_state.dart` (immutable state)
3. Create `feature_handler.dart` (implementation)
4. Create `feature_widget.dart` (UI)
5. Add database repository if needed (`db_feature.dart`)
6. Add model if needed (`models/feature.dart`)

### Media File Import
- Use `file_picker` to select multiple audio/video files at once
- Supported formats: mp3, wav, aac, m4a, mp4, avi, mkv, mov, wmv, flv
- **Auto subtitle detection**: Checks for .srt, .vtt, .sub, .ass files with same name
- **No file copying**: Stores original file paths, doesn't duplicate media
- **Mixed media types**: Single import can include both audio and video files
- **Sort order**: Automatically assigns sortOrder based on existing items

### Database Operations
- Always use async methods: `getByIdAsync()`, `createAsync()`, etc.
- Handle file attachments (covers) with proper lifecycle management
- Use indexed fields for queries (like `sortOrder`)

### State Management
- Use `Stream<State>` for async operations (loading states)
- Use `State` directly for sync operations
- Always yield loading state first for async operations
- Use `copyWith()` for state updates

### Navigation
- Use named routes with parameters: `/playlists/{id}`
- Each tab can have its own nested navigator
- Route generation handled by tab-specific handlers

## Key Dependencies
- **ObjectBox**: Local database with code generation
- **Path Provider**: File system access
- **Image Picker**: Cover image selection
- **File Picker**: Multi-file selection for media import
- Standard Flutter dependencies

## Development Workflow
1. Define feature contract in `*Events` interface
2. Implement business logic in `*Handler`
3. Design immutable state in `*State`
4. Build UI in `*Widget` that reacts to state changes
5. Test with real data using ObjectBox

This architecture enables rapid feature development while maintaining testability and separation of concerns.