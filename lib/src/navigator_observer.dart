import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'components/session_manager.dart';
import 'utils/components.dart';

/// Keeps track of [Navigator] [PageRoute] changes.
///
/// Route names are used to differentiate between pages.
/// Make sure you are consistently specifying them both when:
/// * using [named routes](https://flutter.dev/docs/cookbook/navigation/named-routes) and
/// * pushing a [PageRoute] - using [RouteSettings]
///
/// Without that the events might not get grouped correctly,
/// either resulting in multiple outputs per page/area
/// or a single output that's a mix of multiple pages/areas
///
/// If the current route has no name set a unique
/// identifier will be assigned in its place.
class Observer extends RouteObserver<PageRoute<dynamic>> {
  final _manager = S.get<SessionManager>();

  final _logger = Logger('RoundSpot.Observer');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _onRouteOpened(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _onRouteOpened(previousRoute);
  }

  void _onRouteOpened(Route<dynamic>? route) {
    if (route != null) {
      if (route is! PageRoute) return;
      if (route.settings.name == null) {
        _logger.warning('Current PageRoute has no name set.');
      }
    }
    _manager.onRouteOpened(settings: route?.settings);
  }
}
