import 'package:rxdart/rxdart.dart';
import 'package:tech_news_streams/resources/models/item_model.dart';
import 'package:tech_news_streams/resources/repositories/news_repository.dart';

class CommentsBloc {
  final _newsRepository = NewsRepository();

  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index) {
      print(index);
      cache[id] = _newsRepository.fetchItem(id);
      cache[id]!.then((ItemModel item) {
        item.kids.forEach((kidId) => fetchItemWithComments(kidId));
      });
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
