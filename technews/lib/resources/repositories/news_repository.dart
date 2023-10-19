import 'dart:async';

import '../data_providers/news_api_provider.dart';
import '../data_providers/news_db_provider.dart';
import '../models/item_model.dart';

class NewsRepository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() async {
    late List<int> ids;
    Source source;

    for (source in sources) {
      ids = await source.fetchTopIds();
      if (ids.isNotEmpty) {
        break;
      }
    }

    return ids;
  }

  Future<ItemModel> fetchItem(int id) async {
    print('itemID to be fetched inside repo - $id');
    ItemModel? item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) {
        cache.addItem(item!);
      }
    }
    return item!;
  }

  Future<void> clearCache() async {
    //Because of await it always returns a Future
    for (Cache cache in caches) {
      await cache.clear();
    }
  }
}

//Any provider class whose api can provide us the required data
abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel?> fetchItem(int id);
}

//Any provider class whose api implementation can store the data somewhere
abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
