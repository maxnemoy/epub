import 'package:flutter/material.dart';
import 'package:slide_panel/slide_panel/controller_provider.dart';

Future<void> showResizableBottomSheet({
  required BuildContext context,
  required ResizableBottomSheet sheet,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (c) => sheet,
  );
}

class ResizableBottomSheet extends StatefulWidget {
  final Widget child;
  final double childMaxHeight;
  final double childMinHeight;
  final double bottomMagin;
  final Color background;

  const ResizableBottomSheet({
    Key? key,
    required this.child,
    this.childMaxHeight = .9,
    this.childMinHeight = .1,
    this.bottomMagin = 10,
    this.background = Colors.white,
  }) : super(key: key);

  @override
  State<ResizableBottomSheet> createState() => _ResizableBottomSheetState();
}

class _ResizableBottomSheetState extends State<ResizableBottomSheet> {
  double height = 0;

  @override
  Widget build(BuildContext context) {
    if (height == 0) {
      return _HeightCalculation(
        onCalculateSize: (v) {
          setState(() {
            height = v!.height;
          });
        },
        controller: ScrollController(),
        child: widget.child,
      );
    }

    final double size = ((height + widget.bottomMagin) / MediaQuery.of(context).size.height).clamp(widget.childMinHeight, widget.childMaxHeight);

    return DraggableScrollableSheet(
      maxChildSize: size,
      minChildSize:size - .1,
      initialChildSize: size,
      expand: false,
      builder: (context, controller) {
        return Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: widget.background,
          child: _HeightCalculation(
            onCalculateSize: (v) {
              setState(() {
                height = v!.height;
              });
            },
            controller: controller,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _HeightCalculation extends StatefulWidget {
  final Function(Size? size) onCalculateSize;
  final ScrollController controller;
  final Widget child;

  const _HeightCalculation({
    Key? key,
    required this.controller,
    required this.onCalculateSize,
    required this.child,
  }) : super(key: key);

  @override
  _HeightCalculationState createState() => _HeightCalculationState();
}

class _HeightCalculationState extends State<_HeightCalculation> {
  final key = GlobalKey();

  @override
  initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => getHeight());

    super.initState();
  }

  void getHeight() {
    final size = key.currentContext?.size;
    widget.onCalculateSize(size);
  }

  @override
  Widget build(BuildContext context) {
    return _ChildWrapper(
      key: key,
      controller: widget.controller,
      child: widget.child,
    );
  }
}

class _ChildWrapper extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  const _ChildWrapper({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ControllerProvider(controller: controller, child: child);
  }
}
