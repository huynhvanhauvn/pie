import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/models/word.dart';
import 'package:pie/screens/list_card/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/list_card/blocs/repository.dart';
import 'package:pie/screens/list_card/screen.dart';
import 'package:http/http.dart' as http;
import 'package:pie/screens/search_word/blocs/add_word_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/list_bloc/bloc.dart';
import 'package:pie/screens/search_word/blocs/repository.dart';
import 'package:pie/screens/search_word/screen.dart';

bool isTabletLandscape({@required BuildContext context}) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var orientation = MediaQuery.of(context).orientation;
  return shortestSide >= 600 && orientation == Orientation.landscape;
}

bool isTabletPortrait({@required BuildContext context}) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var orientation = MediaQuery.of(context).orientation;
  return (shortestSide >= 600 && orientation == Orientation.portrait) ||
      (shortestSide < 600 && orientation == Orientation.landscape);
}

bool isPhoneLandscape({@required BuildContext context}) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var orientation = MediaQuery.of(context).orientation;
  return shortestSide < 600 && orientation == Orientation.landscape;
}

// void viewArtistDetail({Artist artist, BuildContext context}) {
//   final ArtistRepository repository =
//       ArtistRepository(httpClient: http.Client());
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => MultiBlocProvider(
//         providers: [
//           BlocProvider<ArtistBloc>(
//             create: (context) => ArtistBloc(repository: repository),
//           ),
//         ],
//         child: ArtistScreen(
//           artist: artist,
//         ),
//       ),
//     ),
//   );
// }

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

void viewWordDetail(Word word, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {}),
  );
}

void viewCardFolder({String idFolder, BuildContext context}) {
  print(idFolder);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListCardBloc(
              repository: ListCardRepository(
                httpClient: http.Client(),
              ),
            ),
          ),
        ],
        child: ListCardScreen(
          idFolder: idFolder,
        ),
      ),
    ),
  );
}

// String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
//     '${alpha.toRadixString(16).padLeft(2, '0')}'
//     '${red.toRadixString(16).padLeft(2, '0')}'
//     '${green.toRadixString(16).padLeft(2, '0')}'
//     '${blue.toRadixString(16).padLeft(2, '0')}';

List<Word> fromJsonToListWord(List<dynamic> listObject) {
  final List<Word> words = List();
  listObject.forEach((element) {
    final Word word = Word(
      id: element['id'] as String,
      word: element['word'] as String ?? '',
      type: element['type'] as String ?? '',
      meaning: element['meaning'] as String ?? '',
      picture: element['picture'] as String ?? '',
      selected: false,
    );
    words.add(word);
  });
  return words;
}

FlashCardSeries fromJsonToListCard(dynamic object) {
  print('convert');
  print(object);
  final List<dynamic> listWord = object['vocab_list'];
  print(listWord);
  final FlashCardSeries series = FlashCardSeries(
    id: object['id'] as String,
    title: object['group_name'] as String ?? '',
    words: fromJsonToListWord(listWord) ?? List(),
    idUser: object['id_user'] as String ?? '',
    createDate: object['created_day'] as String ?? '',
    length: object['num_word'] as String ?? '',
  );
  print(series);
  return series;
}

List<FlashCardSeries> fromJsonToListSeries(List<dynamic> listObject) {
  final List<FlashCardSeries> listSeries = List();
  listObject.forEach((element) {
    final List<dynamic> listWord = element['vocab_list'];
    final FlashCardSeries series = FlashCardSeries(
      id: element['id'] as String,
      title: element['group_name'] as String ?? '',
      words: fromJsonToListWord(listWord) ?? List(),
      idUser: element['id_user'] as String ?? '',
      createDate: element['created_day'] as String ?? '',
      length: element['num_word'] as String ?? '',
    );
    listSeries.add(series);
  });
  return listSeries;
}

Size screenSize({BuildContext context}) {
  return MediaQuery.of(context).size;
}

showAlertDialog(
    {@required BuildContext context,
    String title,
    String content,
    VoidCallback onCancel,
    VoidCallback onContinue}) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Hủy"),
    onPressed: () =>
        onCancel != null ? onCancel() : Navigator.of(context).pop(),
  );
  Widget continueButton = FlatButton(
    child: Text("Tiếp"),
    onPressed: () {
      Navigator.of(context).pop();
      onContinue();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void goToAdd(BuildContext context, idSeries) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListBloc(
              repository: ListRepository(
                httpClient: http.Client(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AddWordBloc(
              repository: ListRepository(
                httpClient: http.Client(),
              ),
            ),
          ),
        ],
        child: SearchWordScreen(idSeries: idSeries,),
      ),
    ),
  );
}
