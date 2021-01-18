import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie/models/flashcard_series.dart';
import 'package:pie/screens/flash_card/blocs/event.dart';
import 'package:pie/screens/flash_card/blocs/list_bloc/state.dart';
import 'package:pie/screens/flash_card/blocs/repository.dart';

class ListGroupBloc extends Bloc<FlashCardEvent, ListGroupState> {
  final FlashCardRepository repository;

  ListGroupBloc({this.repository}): assert(repository!=null), super(ListGroupInitial());

  @override
  Stream<ListGroupState> mapEventToState(FlashCardEvent event) async* {
    if(event is GetListGroup) {
      yield ListGroupLoading();
      try {
        final List<FlashCardSeries> list = await repository.getListGroup();
        print('aka');
        print(list);
        yield ListGroupSuccess(series: list);
      } catch (e) {
        yield ListGroupFailure();
      }
    }
  }
}