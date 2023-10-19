import 'package:flutter/material.dart';

import '../../resources/models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> dataMap;
  final double depth;

  const Comment(
      {required this.itemId, required this.dataMap, required this.depth});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return buildLoadingAnimation(context);
        }
        final comment = snapshot.data;
        final children = <Widget>[
          ListTile(
            dense: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                comment!.by == ''
                    ? Text('Deleted')
                    : Text(
                        comment.by,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                buildText(comment.text),
              ],
            ),
            contentPadding: EdgeInsets.only(
              left: depth * 15.0,
              right: 5.0,
            ),
          ),
        ];

        comment.kids.forEach((kidId) {
          children.add(Comment(
            itemId: kidId,
            dataMap: dataMap,
            depth: depth + 1,
          ));
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(String text) {
    final outputText = text
        .replaceAll('&#x27;', '\'')
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '')
        .replaceAll('<i>', '')
        .replaceAll('</i>', '')
        .replaceAll('&quot;', '\'')
        .replaceAll('&gt;', '>')
        .replaceAll('&lt;', '<')
        .replaceAll('<pre>', '')
        .replaceAll('</pre>', '')
        .replaceAll('<code>', '')
        .replaceAll('</code>', '')
        .replaceAll('&#x2F;', '/')
        .replaceAllMapped(RegExp('<a .*<\/a>'), (match) => '[Link]');
    return Text(
      outputText,
      style: TextStyle(fontSize: 14),
    );
  }

  Widget buildLoadingAnimation(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      height: 24,
      width: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
    );
  }
}
