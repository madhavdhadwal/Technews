import 'dart:convert';

import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:tech_news_streams/resources/data_providers/news_api_provider.dart';

void main() {
  test('fetchTopIds returns a list of IDs', () async {
    final newsApiProvider = NewsApiProvider();
    newsApiProvider.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });
    final ids = await newsApiProvider.fetchTopIds();
    expect(ids, [1, 2, 3, 4]);
  });

  test('fetchItem returns a particular item details', () async {
    final newsApiProvider = NewsApiProvider();
    newsApiProvider.client = MockClient((request) async {
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApiProvider.fetchItem(999);
    expect(item.id, 123);
  });
}
