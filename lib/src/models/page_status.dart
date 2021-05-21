import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'config/config.dart';

/// Current page state used by [SessionManager]
class PageStatus extends Equatable {
  /// Page name set from [RouteSettings.name]
  final String name;

  /// Set if this page was disabled in [Config.disabledRoutes]
  final bool disabled;

  /// Set if this output was was captured from a [PopupRoute]
  final bool isPopup;

  /// Construct a new page status
  PageStatus({required this.name, this.disabled = false, this.isPopup = false});

  @override
  List<Object?> get props => [name, disabled, isPopup];
}
