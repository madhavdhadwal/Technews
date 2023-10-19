import 'package:http/http.dart' show Client;
import 'dart:convert';

import '../models/item_model.dart' show ItemModel;
import '../repositories/news_repository.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    try {
      final response = await client.get(Uri.parse('$_root/topstories.json'));
      //When we decode our json, dart has no idea what is actually inside
      //that list we get back.
      final parsedJsonIds = json.decode(response.body);
      //We are just telling dart that this is going to be a list of integers
      return parsedJsonIds.cast<int>();
    } catch (e) {
      print('Exception caused at Provider (fetchId) - $e');
      rethrow;
    }
  }

  Future<ItemModel> fetchItem(int id) async { 
    print('Inside API provider. Tryna fetch $id');
    try {
      final response = await client.get(Uri.parse('$_root/item/$id.json'));
      final parsedJsonItem = json.decode(response.body);
      final itemModel = ItemModel.fromJson(parsedJsonItem);
      return itemModel;
    } catch (e) {
      print('Tried $id but Exception caused at Provider (fetchItem) - $e');
      rethrow;
 
    }
  }
}
