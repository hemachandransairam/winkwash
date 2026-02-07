import "package:flutter/material.dart";

import "package:wink_dupe/app.dart";
import "package:wink_dupe/core/injection/injection.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await configureDependencies();

  runApp(const App());
}
