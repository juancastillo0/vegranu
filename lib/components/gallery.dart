import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_router/jaspr_router.dart';
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
            padding: Padding.all(0.5.rem),
            margin: Margin.only(top: 1.rem),
            radius: BorderRadius.circular(0.5.rem),
            // alignItems: AlignItems.start,
            // alignContent: AlignContent.spaceEvenly,
            // display: Display.flex,
            // flexWrap: FlexWrap.wrap,
            justifyContent: JustifyContent.center,

            overflow: Overflow.only(
              /* Enables horizontal scrolling when content overflows */
              x: Overflow.auto,
              /* Hides the vertical scrollbar */
              y: Overflow.hidden,
            ),
            /* Prevents content from wrapping to the next line */
            whiteSpace: WhiteSpace.noWrap,
            width: Unit.percent(100),
          ),
          css('img').styles(
            padding: Padding.all(0.5.rem),
            radius: BorderRadius.circular(1.rem),
            display: Display.inlineBlock,
            height: Unit.pixels(300)
          ),
        ])
      ];
}
