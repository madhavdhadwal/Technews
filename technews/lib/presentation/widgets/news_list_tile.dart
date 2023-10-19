import 'package:flutter/material.dart';

import 'loading_list_tile.dart';
import '../../business_logic/blocs/stories_bloc_provider.dart';
import '../../resources/models/item_model.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;
  NewsListTile({required this.itemId});
  Widget build(BuildContext context) {
    final bloc = StoriesBlocProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return loadingListTile();
        }
        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return loadingListTile();
            }
            return buildTile(itemSnapshot.data!, context);
          },
        );
      },
    );
  }

  Widget buildTile(ItemModel item, BuildContext context) {
    return Column(children: [
      ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/${item.id}');
        },
        title: Text(item.title),
        subtitle: Text(
          '${item.score} points',
          style: TextStyle(
            color: Colors.pink[200],
          ),
        ),
        trailing: Column(
          children: [
            Image.asset(
              'assets/images/comment.png',
              scale: 16,
            ),
            Text('${item.descendants}')
          ],
        ),
      ),
      Divider(
        height: 8.0,
      ),
    ]);
  }
}
