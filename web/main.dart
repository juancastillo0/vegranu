// Client-specific import
import 'package:jaspr/browser.dart';

// Our main component
import 'package:vegranu/main.dart';

void main() {
  // Attaches the app component to the <body> tag
  // and hydrates the component / makes it interactive.
  runApp(App(), attachTo: 'body');
}
