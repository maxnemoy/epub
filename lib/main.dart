import 'dart:typed_data';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:slide_panel/slide_panel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Brightness get platformBrightness =>
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
          .platformBrightness;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EpubController _epubReaderController;
  String txt = "";
  int index = 0;

  @override
  void initState() {
    final loadedBook = _loadFromAssets('assets/1.epub');
    _epubReaderController = EpubController(
      document: EpubReader.readBook(loadedBook),
    );
    super.initState();
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  Future<Uint8List> _loadFromAssets(String assetName) async {
    final bytes = await rootBundle.load(assetName);
    return bytes.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: EpubView(
          onInternalLinkPressed: (refIndex, text) {
            setState(() {
              txt = text;
              index = refIndex;
              showResizableBottomSheet(
                  context: context,
                  sheet: ResizableBottomSheet(
                      child: SheetView(
                          title: "Приложение $index", body: Text(txt))));
              // showModalBottomSheet(
              // context: context,
              // isScrollControlled: true,
              
              // builder: (context) {
              //   return FractionallySizedBox(
              //     //heightFactor: 0.8,
              //     child: SheetView( title: "Приложение $index", body: Text(txt)),
              //   );
              // });
            });
          },
          controller: _epubReaderController,
          dividerBuilder: (_) => Divider(),
        ),
      );
}
