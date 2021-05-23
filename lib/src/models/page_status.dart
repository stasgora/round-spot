import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'config/config.dart';

/// Current page state used by [SessionManager]
class PageStatus extends Equatable {
  /// Page name set from [RouteSettings.name]
  final String name;

  /// Set if the name was missing on the [RouteSettings]
  final bool nameMissing;

  /// Set if this page was disabled in [Config.disabledRoutes]
  final bool disabled;

  /// Set if this output was was captured from a [PopupRoute]
  final bool isPopup;

  /// Future that ends with the route transition animation
  final Future transitionEnded;

  /// Duration being waited for by [transitionEnded]
  @visibleForTesting
  final Duration transitionDuration;

  /// Construct a new page status
  PageStatus({
    String? name,
    this.disabled = false,
    this.isPopup = false,
    this.transitionDuration = Duration.zero,
  })  : name = name ?? '${DateTime.now()}',
        nameMissing = name == null,
        transitionEnded = Future.delayed(transitionDuration);

  @override
  List<Object?> get props => [name, nameMissing, disabled, isPopup];
}
