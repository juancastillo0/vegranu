// The entrypoint for the **server** environment.
//
// The [main] method will only be executed on the server during pre-rendering.
// To run code on the client, use the @client annotation.

// Server-specific jaspr import.
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/header.dart';

import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/components/github_button.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/theme.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:recase/recase.dart';
import 'package:vegranu/components/sidebar.dart';
import 'package:vegranu/routes_map.dart';

import 'components/clicker.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'jaspr_options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultJasprOptions,
  );

  // Starts the app.
  //
  // [ContentApp] spins up the content rendering pipeline from jaspr_content to render
  // your markdown files in the content/ directory to a beautiful documentation site.
  runApp(
    Document(
      head: [
        // Links to the compiled `web/main.dart` file.
        script(src: 'main.dart.js'),
      ],
      // Pre-renders the [App] component inside the <body> tag
      body: App(),
    ),
  );
}

class App extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return ContentApp(
      // Enables mustache templating inside the markdown files.
      templateEngine: MustacheTemplateEngine(),
      parsers: [
        MarkdownParser(),
      ],
      extensions: [
        // Adds heading anchors to each heading.
        HeadingAnchorsExtension(),
        // Generates a table of contents for each page.
        TableOfContentsExtension(),
      ],
      components: [
        // The <Info> block and other callouts.
        Callout(),
        // Adds syntax highlighting to code blocks.
        CodeBlock(),
        // Adds a custom Jaspr component to be used as <Clicker/> in markdown.
        CustomComponent(
          pattern: 'Clicker',
          builder: (_, __, ___) => Clicker(),
        ),
        // Adds zooming and caption support to images.
        Image(zoom: true),
      ],
      eagerlyLoadAllPages: true,
      layouts: [
        // Out-of-the-box layout for documentation sites.
        DocsLayout(
          header: Header(
            title: 'Vegranu',
            logo: '/images/vegranu-logo-darkbg.png',
            items: [
              // Enables switching between light and dark mode.
              ThemeToggle(),
              // Shows github stats.
              GitHubButton(repo: 'juancastillo0/vegranu'),
            ],
          ),
          sidebar: AppSidebar(),
        ),
      ],
      theme: ContentTheme(
        // Customizes the default theme colors.
        primary: ThemeColor(ThemeColors.blue.$500, dark: ThemeColors.blue.$300),
        background:
            ThemeColor(ThemeColors.slate.$50, dark: ThemeColors.zinc.$950),
        colors: [
          ContentColors.quoteBorders.apply(ThemeColors.blue.$400),
        ],
      ),
    );
  }
}

class AppSidebar extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    final fullPath = Router.of(context).matchList.uri;
    print(fullPath.pathSegments);
    final firstRoutePath = fullPath.pathSegments.firstOrNull;
    final nested = routesMap[firstRoutePath];
    const routeTitles = {
      'about': 'About',
      'ingredients': 'Auxiliary Ingredients',
      'cooking-insights': 'Cooking Insights & Tools',
      'habits': 'Health Habits',
      'meals': 'Meals',
      'meal-plans': 'Meal Plans',
      'principles': 'Principles',
      'swaps-challenges': 'Swaps & Tips',
      'questions': 'Questions & Answers',
    };

    const itemsWithIcons = {
      'auxiliary-ingredients',
      'bread',
      'cakes-brownies-cookies',
      'cooking-insights',
      'drinks-shakes-smoothies',
      'ferments-kimchi',
      'milks-yogurts',
    };
    List<SidebarLink> nestedLinks = [];
    if (nested != null) {
      // && fullPath.pathSegments.length == 2
      nestedLinks = nested
          .map(
            (e) => SidebarLink(
              text: ReCase(e).titleCase,
              href: '/$firstRoutePath/$e',
              icon: itemsWithIcons.contains(e)
                  ? '/images/page-icons/$e.png'
                  : null,
            ),
          )
          .toList();
      // return Sidebar(groups: [
      //   SidebarGroup(
      //     links: [
      //       SidebarLink(text: 'Overview', href: '/'),
      //     ],
      //   ),
      //   SidebarGroup(
      //     title: routeTitles[firstRoutePath] ?? 'Content',
      //     links: nestedLinks,
      //   ),
      // ]);
    }

    return Sidebar(groups: [
      // Adds navigation links to the sidebar.
      SidebarGroup(links: [SidebarLink(text: 'Overview', href: '/')]),
      if (nestedLinks.isNotEmpty)
        SidebarGroup(
          title: routeTitles[firstRoutePath] ?? 'Group',
          links: nestedLinks,
        ),
      SidebarGroup(title: 'Content', links: [
        ...routeTitles.entries.map(
          (e) => SidebarLink(
            text: e.value,
            href: '/${e.key}',
            icon: itemsWithIcons.contains(e.key)
                ? '/images/page-icons/${e.key}.png'
                : null,
          ),
        ),
      ]),
    ]);
  }
}

enum Taste {
  savory,
  sweet,
  acid,
  umami,
}

enum FoodType {
  auxiliary,
  snack,
  side,
  drink,
  breakfast,
  lunch,
  dinner,
}
