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
  "assets/2.epub", //full
  "assets/23.epub", // 23 Temmuz
  "assets/24.epub", // 24 Temmuz
  "assets/notes.epub", // notes
  ];

class BookList extends StatefulWidget {
  const BookList({ Key? key }) : super(key: key);

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
late EpubController _epubNotes;
@override
void initState() {
    final notesBook =  _loadFromAssets("assets/notes.epub");
    _epubNotes = EpubController(
    document: EpubReader.readBook(notesBook),
  );
  super.initState();
}

  Future<Uint8List> _loadFromAssets(String assetName) async {
    final bytes = await rootBundle.load(assetName);
    return bytes.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: books.map((e) => ListTile(
          title: Text(e),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewPage(bookPath: e, epubNotes: _epubNotes,)));
          },
        )).toList(),
      ),
    );
  }
}


class ViewPage extends StatefulWidget {
  const ViewPage({Key? key, required this.bookPath, required this.epubNotes}) : super(key: key);
  final String bookPath;
  final EpubController epubNotes;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late EpubController _epubReaderController;
  late String title;
  

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
    appBar: AppBar(
      actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.calendar_today))],
      title: Column(children: [
      const Text("Мишне Тора. Книга любовь.", style: TextStyle(fontSize: 16),),
      Text("23 тамуз 5181 - 3 июль 2021", style: Theme.of(context).textTheme.caption,)
    ]), centerTitle: true),
        body: EpubView(
          hideElements: const ["_idFootnote", "_idFootnotes"],
          onInternalLinkLoad: (isLoad){
          },
          onInternalLinkPressed: (refIndex, text) {
              showResizableBottomSheet(
                  context: context,
                  sheet: ResizableBottomSheet(
                      child: SheetView(
                          title: "Примечание $refIndex", body: Text(text))));
          },
          controller: _epubReaderController,
          notesController: widget.epubNotes,
          dividerBuilder: (_) => const Divider(),
        ),
      );
}
