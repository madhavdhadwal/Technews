import 'package:rxdart/rxdart.dart';

import '../../resources/repositories/news_repository.dart';
import '../../resources/models/item_model.dart';

class StoriesBloc {
  final _newsRepository = NewsRepository();

  //Initialise a streamController that will contain data (sink and stream)
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //Getters to streams
  Stream<List<int>> get topIds => _topIds.stream;
  //Anytime NewsListTile streamBuilder subscribes to it, a single
  //subscription is created
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Adding data into _items stream
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    //Pipe takes every output from a stream and automatically
    //forwards it to soem target destination stream
    //Central transform field that has a single subscriber: _itemsOutput
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  //A widget will call this function
  fetchTopIds() async {
    final ids = await _newsRepository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  Future<void> clearCache() async {
    await _newsRepository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      //Function that gets invoked everytime a new element/data
      //event comes into this transformer
      //cache -> reference to our second element
      //id -> whatever is coming through our stream
      //index -> number of times our scanStreamTransformer has
      //been invoked. No of times event has come
      (Map<int, Future<ItemModel>> cache, int id, index) {
        print(index);
        cache[id] = _newsRepository.fetchItem(id);
        return cache;
      },
      //Initial value - empty cache map
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
