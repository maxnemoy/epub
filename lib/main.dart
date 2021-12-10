import 'dart:typed_data';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiOverlayStyle, rootBundle;
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

  @override
  void didChangePlatformBrightness() {
    _setSystemUIOverlayStyle();
  }

  Brightness get platformBrightness =>
      MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
          .platformBrightness;

  void _setSystemUIOverlayStyle() {
    if (platformBrightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[50],
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey[850],
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Epub demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
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
  late SlidePanelController _controller;
  String txt = "";
  int index = 0;

  @override
  void initState() {
    final loadedBook =
        _loadFromAssets('assets/1.epub');
    _epubReaderController = EpubController(
      document: EpubReader.readBook(loadedBook),
    );
    _controller = SlidePanelController();
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
        onInternalLinkPressed: (refIndex, text){
          setState(() {
            txt = text;
            index = refIndex;
            // _controller.showPanel();
            showModalBottomSheet(
              isScrollControlled: true,
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*.95),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20)
                )
              ),
              context: context, 
              builder: (context)=>SlideBody(
                title: "Примечание $index",
                body: Text(txt),
              ),
              );
          });
        },
        controller: _epubReaderController,
        dividerBuilder: (_) => Divider(),
        ),
      );

}


class SlideBody extends StatelessWidget {
  final String title;
  final Widget body;
  final Color backgroundColor;
  final Color accentColor;
  final TextStyle titleTextStyle;

  SlideBody({ Key? key, 
  required this.title, 
  required this.body, 
  this.backgroundColor = Colors.white, 
  this.accentColor = Colors.orange,
  SlidePanelController? controller, 
  TextStyle? titleTextStyle
  }) :
  titleTextStyle = titleTextStyle ?? TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: accentColor),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(
                                height: 5,
                                width: 40,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(2))),
                              )],),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25, left: 25, bottom: 20),
                              child: Text(title, style: titleTextStyle,),
                            ),
    
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Container(color: accentColor, height: 2, width: double.infinity,),
                            ),
                            ConstrainedBox(                      
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*.8),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 35, left: 25),
                                child: SingleChildScrollView(child: IntrinsicHeight(child: Container(
                                  width: double.infinity,
                                  color: accentColor.withOpacity(0.05),
                                  padding: const EdgeInsets.only(left: 20, right: 10, bottom: 20),
                                  child: body))),
                              )),
                          ],
                        ),
    );
  }
}