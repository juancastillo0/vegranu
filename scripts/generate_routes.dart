import 'dart:io';

Future<void> main() async {
  final rootContentDir = Directory('content');
  final dirToContent = <String, List<String>>{};
  await for (final d in rootContentDir.list()) {
    final dirName = d.uri.pathSegments.lastWhere((v) => v.isNotEmpty);
    if (d is! Directory || dirName == '_data') continue;
    final l = dirToContent.update(dirName, (s) => s, ifAbsent: () => []);
    await for (final f in d.list()) {
      final name = f.uri.pathSegments.lastWhere((v) => v.isNotEmpty);
      if (!name.startsWith(RegExp('[._]')) &&
          name != 'index.md' &&
          name.endsWith('.md')) {
        l.add(name.substring(0, name.length - 3));
      }
    }
  }

  final photosDir = Directory('web/images/photos');
  final photosDirPath = photosDir.uri.toFilePath(windows: false);
  final dirToPhotos = <String, List<String>>{};
  final photosToDelete = <File>[];
  await for (final d in photosDir.list(recursive: true)) {
    final path = d.uri.toFilePath(windows: false);
    final segments = path.substring(photosDirPath.length).split('/');
    final name = segments.lastWhere((v) => v.isNotEmpty);
    if (d is File && name.startsWith('._') && name.endsWith('.jpg'))
      photosToDelete.add(d);
    if (d is! File || name.startsWith(RegExp('[._]'))) continue;

    dirToPhotos.update(segments.first, (s) => s, ifAbsent: () => []).add(name);
  }
  print(dirToContent);
  print(dirToPhotos);
  print(photosToDelete);
  for (final d in photosToDelete) {
    await d.delete();
  }
  print('deleted $photosToDelete');

  File('lib/routes_map.dart').writeAsString('''
const routesMap = {
${dirToContent.entries.map((e) => '"${e.key}": ["${e.value.join('", "')}"],').join('\n')}
};
const dirPhotos = {
${dirToPhotos.entries.map((e) => '"${e.key}": ["${e.value.join('", "')}"],').join('\n')}
};
''');
  await Process.run('dart', ['format', 'lib/routes_map.dart']);
}
