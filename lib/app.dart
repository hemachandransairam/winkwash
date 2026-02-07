import "package:flutter/material.dart";
import "package:mix/mix.dart";

import "package:wink_dupe/core/injection/injection.dart";
import "package:wink_dupe/core/routing/router.dart";
import "package:wink_dupe/core/theme/theme.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();

    return MixTheme(
      data: LightTheme.theme,
      child: MaterialApp.router(
        title: "Wink Dupe",
        debugShowCheckedModeBanner: false,
        routerConfig: router.config(),
      ),
    );
  }
}
