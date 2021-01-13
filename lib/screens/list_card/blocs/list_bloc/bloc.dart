import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/list_card/blocs/event.dart';
import 'package:pie/screens/list_card/blocs/list_bloc/state.dart';
import 'package:pie/screens/list_card/blocs/repository.dart';

class ListCardBloc extends Bloc<ListCardEvent, ListCardState> {
  final ListCardRepository repository;

  ListCardBloc({this.repository}): assert(repository!=null), super(ListCardInitial());

  @override
  Stream<ListCardState> mapEventToState(ListCardEvent event) async* {
    if(event is GetListCard) {
      yield ListCardLoading();
      try {
        final FlashCardSeries list = await repository.getListCard(id: event.id);
        print('day la list');
        // print(list);
        yield ListCardSuccess(series: list);
      } catch (e) {
        yield ListCardFailure();
      }
    }
  }
}