import 'dart:typed_data';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:slide_panel/slide_panel.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BookList(),
    );
  }
}

const List<String> books = [
  "assets/1.epub", //broken
  "assets/2.epub",
  "assets/3.epub",
  "assets/5.epub",
  "assets/12.epub", //broken
  ];

class BookList extends StatelessWidget {
  const BookList({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: books.map((e) => ListTile(
          title: Text(e),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewPage(bookPath: e,)));
          },
        )).toList(),
      ),
    );
  }
}


class ViewPage extends StatefulWidget {
  const ViewPage({Key? key, required this.bookPath}) : super(key: key);
  final String bookPath;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late EpubController _epubReaderController;

  @override
  void initState() {
    final loadedBook = _loadFromAssets(widget.bookPath);
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
              showResizableBottomSheet(
                  context: context,
                  sheet: ResizableBottomSheet(
                      child: SheetView(
                          title: "Приложение $refIndex", body: Text(text))));
          },
          controller: _epubReaderController,
          dividerBuilder: (_) => const Divider(),
        ),
      );
}
