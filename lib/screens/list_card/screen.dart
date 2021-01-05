import 'package:flutter/material.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/list_card/widgets/flip_cart.dart';
import 'package:pie/utils/app_functions.dart';

class ListCardScreen extends StatefulWidget {
  List<Word> words = [
    Word(id: 0, word: 'run', type: 'v', meaning: 'Chạy', picture: ''),
    Word(id: 1, word: 'learn', type: 'v', meaning: 'Học tập', picture: ''),
    Word(id: 2, word: 'house', type: 'n', meaning: 'Nhà', picture: ''),
  ];
  final int idFolder;

  ListCardScreen({@required this.idFolder});

  @override
  State<StatefulWidget> createState() => ListCardScreenDetail();
}

class ListCardScreenDetail extends State<ListCardScreen> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.words;
    return Scaffold(
      body: Stack(
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
      ),
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
