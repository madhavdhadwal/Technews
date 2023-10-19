import 'package:flutter/material.dart';
import 'package:tech_news_streams/presentation/widgets/comment.dart';
import 'package:tech_news_streams/presentation/widgets/custom_app_bar.dart';

import '../../business_logic/blocs/comments_bloc.dart';
import '../../business_logic/blocs/comments_bloc_provider.dart';
import '../../resources/models/item_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final int itemId;
  const NewsDetailScreen({required this.itemId});

  Widget build(BuildContext context) {
    CommentsBloc bloc = CommentsBlocProvider.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Story Details',
        isCenter: true,
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments, 
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading');
        }
        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Still Loading');
            }
            return displayBody(itemSnapshot.data!, snapshot.data!);
          },
        );
      },
    );
  } 

  Widget displayBody(ItemModel item, Map<int, Future<ItemModel>> dataMap) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showTitle(item.title),
            SizedBox(
              height: 5.0,
            ),
            Text(
              item.by,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              '${item.score} points ~${item.kids.length} comments',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15,
                bottom: 5,
              ),
              child: Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            showComments(item.kids.cast<int>(), dataMap),
          ],
        ));
  }

  Widget showTitle(String title) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget showComments(
      List<int> commentIds, Map<int, Future<ItemModel>> dataMap) {
    var count = 0;
    final commentsList = commentIds.map((kidId) {
      count++;
      return ExpansionTile(
          initiallyExpanded: count == 1,
          title: Text(
            'Thread - $count',
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          children: [
            Comment(
              itemId: kidId,
              dataMap: dataMap,
              depth: 0,
            ),
            Divider()
          ]);
    }).toList();

    //Expand to solve ListView bottom overflow
    return commentsList.isNotEmpty
        ? Expanded(
            child: ListView(
              //To stop ListView having unbounded height
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: commentsList,
            ),
          )
        : Center(
            heightFactor: 25,
            child: Text('No comments yet!!'),
          ); 
  }
}
