import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        //if deleted is null, assign false
        deleted = parsedJson['deleted'] ?? false,
        type = parsedJson['type'] ?? '',
        by = parsedJson['by'] ?? '',
        time = parsedJson['time'] ?? 0,
        text = parsedJson['text'] ?? '',
        dead = parsedJson['dead'] ?? false,
        parent = parsedJson['parent'] ?? 0,
        kids = parsedJson['kids'] ?? [],
        url = parsedJson['url'] ?? '',
        score = parsedJson['score'] ?? 0,
        title = parsedJson['title'] ?? '',
        descendants = parsedJson['descendants'] ?? 0;

  ItemModel.fromDb(Map<String, dynamic> mapFromDb)
      : id = mapFromDb['id'],
        deleted = mapFromDb['deleted'] == 1,
        type = mapFromDb['type'],
        by = mapFromDb['by'],
        time = mapFromDb['time'],
        text = mapFromDb['text'],
        dead = mapFromDb['dead'] == 1,
        parent = mapFromDb['parent'],
        kids = jsonDecode(mapFromDb['kids']),
        url = mapFromDb['url'],
        score = mapFromDb['score'],
        title = mapFromDb['title'],
        descendants = mapFromDb['descendants'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'by': by,
      'time': time,
      'text': text,
      'title': title,
      'dead': dead ? 1 : 0,
      'parent': parent,
      'kids': jsonEncode(kids),
      'url': url,
      'score': score,
      'descendants': descendants,
    };
  }
}
