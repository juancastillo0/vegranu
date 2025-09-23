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
  print(dirToContent);
  File('lib/routes_map.dart').writeAsString('''
const routesMap = {
${dirToContent.entries.map((e) => '"${e.key}": ["${e.value.join('", "')}"],').join('\n')}
};
''');
  await Process.run('fvm', ['dart', 'format', 'lib/routes_map.dart']);
}
