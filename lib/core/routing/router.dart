import "package:auto_route/auto_route.dart";
import "package:wink_dupe/features/auth/presentation/views/login.view.dart";

import "router.gr.dart";

@AutoRouterConfig(replaceInRouteName: "View,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
  ];
}
