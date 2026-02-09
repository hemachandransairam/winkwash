import "package:auto_route/auto_route.dart";

import "router.gr.dart";

@AutoRouterConfig(replaceInRouteName: "View|Page|Screen,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page, path: "/home"),
  ];
}
