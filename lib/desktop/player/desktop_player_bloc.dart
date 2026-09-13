
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingbird/desktop/player/desktop_player_event.dart';
import 'package:mockingbird/desktop/player/desktop_player_state.dart';

class DesktopPlayerBloc extends Bloc<DesktopPlayerEvent, DesktopPlayerState> {
  DesktopPlayerBloc() : super(const DesktopPlayerEmptyState()) {
    on<DesktopPlayerLoadMediaEvent>(_loadMedia);
  }

  void _loadMedia(DesktopPlayerLoadMediaEvent event, Emitter<DesktopPlayerState> emit) {

  }
  // onTap
  // final result = await FilePicker.pickFiles(
  //   type: FileType.custom,
  //   allowedExtensions: [
  //     'mp4',
  //     'mov',
  //     'avi',
  //     'mkv',
  //     'mp3',
  //     'wav',
  //     'm4a',
  //     'flac',
  //   ],
  // );
  // if (result.isNotEmpty) {
  //   if (context.mounted) {
  //     _handleFileSelection(context, result.first.xFile.path);
  //   }
  // }
  
  // Future<void> _handleFileSelection(
  //   BuildContext context,
  //   String filePath,
  // ) async {
  //   try {
  //     EasyLoading.show(status: 'Loading media file...');
  //     final fileName = filePath.split(Platform.pathSeparator).last;

  //     final assetPaths = await PhotoManager.getAssetPathList(
  //       type: RequestType.video | RequestType.audio,
  //     );

  //     AssetEntity? matchedAsset;
  //     for (final path in assetPaths) {
  //       final assetCount = await path.assetCountAsync;
  //       final assets = await path.getAssetListRange(start: 0, end: assetCount);
  //       for (final asset in assets) {
  //         final file = await asset.file;
  //         if (file?.path == filePath ||
  //             asset.title?.toLowerCase() == fileName.toLowerCase()) {
  //           matchedAsset = asset;
  //           break;
  //         }
  //       }
  //       if (matchedAsset != null) break;
  //     }

  //     if (matchedAsset == null) {
  //       final lowercasePath = filePath.toLowerCase();
  //       if (lowercasePath.endsWith('.mp4') ||
  //           lowercasePath.endsWith('.mov') ||
  //           lowercasePath.endsWith('.avi') ||
  //           lowercasePath.endsWith('.mkv')) {
  //         matchedAsset = await PhotoManager.editor.saveVideo(
  //           File(filePath),
  //           title: fileName,
  //         );
  //       } else {
  //         matchedAsset = await PhotoManager.editor.saveImageWithPath(
  //           filePath,
  //           title: fileName,
  //         );
  //       }
  //     }

  //     if (context.mounted) {
  //       context.read<DesktopPlayerBloc>().add(
  //         PlayerInitEvent(mediaId: matchedAsset.id),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Error handling file selection: $e');
  //     EasyLoading.showError('Failed to load file into player.');
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }
}