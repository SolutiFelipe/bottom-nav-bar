import 'package:flutter/widgets.dart';

class AppFlow {
  final String title;
  final IconData iconData;
  final Color mainColor;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppFlow({
    @required this.title,
    @required this.mainColor,
    @required this.iconData,
    @required this.navigatorKey,
  })  : assert(title != null),
        assert(mainColor != null),
        assert(iconData != null),
        assert(navigatorKey != null);
}
