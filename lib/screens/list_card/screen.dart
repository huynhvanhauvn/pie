import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/list_card/blocs/event.dart';
import 'package:pie/screens/list_card/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/list_card/blocs/list_bloc/state.dart';
import 'package:pie/screens/list_card/widgets/flip_cart.dart';
import 'package:pie/utils/app_functions.dart';

class ListCardScreen extends StatefulWidget {
  // List<Word> words = [
  //   Word(id: '0', word: 'run', type: 'v', meaning: 'Chạy', picture: ''),
  //   Word(id: '1', word: 'learn', type: 'v', meaning: 'Học tập', picture: ''),
  //   Word(id: '2', word: 'house', type: 'n', meaning: 'Nhà', picture: ''),
  // ];
  final String idFolder;

  ListCardScreen({@required this.idFolder});

  @override
  State<StatefulWidget> createState() => ListCardScreenDetail();
}

class ListCardScreenDetail extends State<ListCardScreen> {
  PageController _pageController;

  FlutterTts tts = FlutterTts();

  Future _speak(Word word) async {
    await tts.setLanguage("en-US");
    await tts.setSpeechRate(1.0);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    var result = await tts.speak(word.word);
  }

  void displayBottomSheet(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 16,
                child: IconButton(
                  onPressed: () => _speak(word),
                  icon: Icon(
                    Icons.volume_up_rounded,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        word.word,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      Text(
                        '(${word.type})',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 18),
                      ),
                      Text(
                        word.meaning,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _pageController = PageController();
    BlocProvider.of<ListCardBloc>(context)
        .add(GetListCard(id: widget.idFolder));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ListCardBloc, ListCardState>(builder: (context, state) {
        if (state is ListCardSuccess) {
          print(state.series);
          final List<Word> words = state.series.words;
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final Word word = words[index];
                  return Dismissible(
                    onDismissed: (direction) {
                      if (direction == DismissDirection.up) {
                        setState(() {
                          words.removeAt(index);
                        });
                      }
                      if (direction == DismissDirection.down) {
                        showAlertDialog(
                          context: context,
                          title: 'Thông báo',
                          content: 'Bạn có muốn xóa từ này khỏi danh sách?',
                          onContinue: () => setState(() {
                            words.removeAt(index);
                          }),
                        );
                      }
                    },
                    direction: DismissDirection.vertical,
                    key: UniqueKey(),
                    child: Center(
                      child: Container(
                        height: 200,
                        child: FlipCard(
                          onLongPress: () => displayBottomSheet(context, word),
                          direction: FlipDirection.VERTICAL, // default
                          front: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    color: Colors.grey.withOpacity(0.2)),
                              ],
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                word.word,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          back: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    color: Colors.grey.withOpacity(0.2)),
                              ],
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                word.meaning,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: words.length,
              ),
              Positioned(
                bottom: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_left_rounded,
                          size: 50,
                        ),
                        onPressed: () => scrollTopStart()),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_right_rounded,
                          size: 50,
                        ),
                        onPressed: () => scrollTopEnd(words)),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      }),
      appBar: AppBar(
        title: Text('Detail'),
      ),
    );
  }

  void scrollTopStart() {
    _pageController.animateToPage(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }

  void scrollTopEnd(List<dynamic> list) {
    _pageController.animateToPage(
      list.length - 1,
      duration: Duration(seconds: 1),
      curve: Curves.ease,
    );
  }
}
