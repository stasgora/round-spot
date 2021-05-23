import 'package:flutter/widgets.dart';

import 'components/session_manager.dart';
import 'models/config/config.dart';
import 'models/page_status.dart';
import 'utils/components.dart';

/// Keeps track of [Navigator] [PageRoute] changes.
///
/// Route names are used to differentiate between pages.
/// Make sure you are consistently specifying them both when
/// using [named routes](https://flutter.dev/docs/cookbook/navigation/named-routes)
/// and pushing a [PageRoute] (inside [RouteSettings])
///
/// Without that the events might not get grouped correctly,
/// either resulting in multiple outputs per page/area
/// or a single output that's a mix of multiple pages/areas
///
/// If the current route has no name set a unique
/// identifier will be assigned in its place.
class Observer extends RouteObserver<ModalRoute<dynamic>> {
  final _manager = S.get<SessionManager>();
  final _config = S.get<Config>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _onRouteOpened(route, _getLongestTransition(route, previousRoute));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _onRouteOpened(previousRoute, _getLongestTransition(route, previousRoute));
  }

  Duration _getLongestTransition(
    Route<dynamic> primary,
    Route<dynamic>? secondary,
  ) {
    var duration = Duration.zero;
    if (primary is TransitionRoute) duration = primary.transitionDuration;
    if (secondary != null && secondary is TransitionRoute) {
      duration += secondary.reverseTransitionDuration;
    }
    return duration;
  }

  void _onRouteOpened(Route<dynamic>? route, Duration transitionDuration) {
    PageStatus? status;
    if (route != null) {
      if (route is! ModalRoute) return;
      status = PageStatus(
        name: route.settings.name,
        disabled: _config.disabledRoutes.contains(route.settings.name),
        isPopup: route is PopupRoute,
        transitionDuration: transitionDuration,
      );
    }
    _manager.onRouteOpened(status);
  }
}
