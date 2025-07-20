import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Show scrollbars on all platforms
    return Scrollbar(
      controller: details.controller,
      child: child,
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Use bouncing overscroll on all platforms
    return child;
  }
}

class AppScrollConfiguration extends StatelessWidget {
  final Widget child;

  const AppScrollConfiguration({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: child,
    );
  }
}
