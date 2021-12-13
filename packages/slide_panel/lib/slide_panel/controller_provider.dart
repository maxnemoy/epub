import 'package:flutter/material.dart';

class ControllerProvider extends InheritedWidget {
  const ControllerProvider({
    Key? key,
    this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final ScrollController? controller;

  static ControllerProvider of(BuildContext context) {
    final ControllerProvider? result = context.dependOnInheritedWidgetOfExactType<ControllerProvider>();
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ControllerProvider old) => controller != old.controller;
}