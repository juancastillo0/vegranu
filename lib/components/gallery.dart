import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:vegranu/routes_map.dart';

@client
class Gallery extends StatefulComponent {
  const Gallery({
    super.key,
    required this.directory,
    this.omittedPaths,
  });

  final List<String>? omittedPaths;
  final String directory;

  @override
  State<Gallery> createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  int count = 0;

  @override
  Component build(BuildContext context) {
    // final fullPath = Router.of(context)
    //     .matchList
    //     .uri
    //     .pathSegments
    //     .lastWhere((p) => p.isNotEmpty);
    final fullPath = '';
    final paths = dirPhotos[component.directory] ?? dirPhotos[fullPath] ?? [];

    return div(
      classes: 'gallery',
      [
        for (final p in paths)
          img(src: '/images/photos/${component.directory}/$p')
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
        css('.gallery', [
          css('&').styles(
            width: Unit.percent(100),
            padding: Padding.all(0.5.rem),
            margin: Margin.only(top: 1.rem),
            // alignItems: AlignItems.start,
            // alignContent: AlignContent.spaceEvenly,
            // display: Display.flex,
            // flexWrap: FlexWrap.wrap,
            radius: BorderRadius.circular(0.5.rem),
            overflow: Overflow.only(x: Overflow.auto, y: Overflow.hidden),
            /* Prevents content from wrapping to the next line */
            justifyContent: JustifyContent.center,
            whiteSpace: WhiteSpace.noWrap,
          ),
          css('img').styles(
            display: Display.inlineBlock,
            height: Unit.pixels(300),
            radius: BorderRadius.circular(1.rem),
            padding: Padding.all(0.5.rem),
          ),
        ])
      ];
}
