
import 'package:mockingbird/models/track.dart';
import 'package:mockingbird/objectbox.g.dart';

class DBTrack {
  final Store _store;
  DBTrack(this._store);

  Future<List<Track>> createManyAsync(List<Track> tracks) async {
    if (tracks.isEmpty) return [];

    await _store.box<Track>().putManyAsync(tracks);
    return tracks;
  }

  Future<List<Track>> getByPlaylistIdAsync(int playlistId) async {
    // Note: Track doesn't have playlistId field in current model
    // This would need to be implemented based on actual relationship design
    final query = _store.box<Track>()
        .query()
        .order(Track_.name)
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }
}
