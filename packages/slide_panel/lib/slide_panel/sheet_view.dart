import 'package:flutter/material.dart';
import 'package:slide_panel/slide_panel/controller_provider.dart';

class SheetView extends StatelessWidget {
  SheetView(
      {Key? key,
      required this.title,
      required this.body,
      this.backgroundColor = Colors.white,
      this.accentColor = Colors.orange,
      TextStyle? titleTextStyle})
      : titleTextStyle = titleTextStyle ??
            TextStyle(
                fontSize: 18, fontStyle: FontStyle.italic, color: accentColor),
        super(key: key);

  final String title;
  final Widget body;
  final Color backgroundColor;
  final Color accentColor;
  final TextStyle titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(2))),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, bottom: 20),
            child: Text(
              title,
              style: titleTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Container(
              color: accentColor,
              height: 2,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 25),
              child: SingleChildScrollView(
                  controller: ControllerProvider.of(context).controller,
                  child: Container(
                      width: double.infinity,
                      color: accentColor.withOpacity(0.05),
                      padding:
                          const EdgeInsets.only(left: 25, right: 20, bottom: 20),
                      child: body))
            ),
          ),
        ],
      ),
    );
  }
}
