import 'package:flutter/material.dart';
import 'package:tech_news_streams/presentation/widgets/custom_app_bar.dart';

import '../widgets/refresh.dart';
import '../widgets/news_list_tile.dart';
import '../../business_logic/blocs/stories_bloc_provider.dart';

class NewsListScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final storiesBloc = StoriesBlocProvider.of(context);
    //storiesBloc.fetchTopIds();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tech News',
      ),
      body: buildList(storiesBloc),
    );
  }

  Widget buildList(StoriesBloc storiesBloc) {
    return StreamBuilder(
      stream: storiesBloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, int index) {
              storiesBloc.fetchItem(snapshot.data![index]);
              return NewsListTile(
                itemId: snapshot.data![index],
              );
            },
          ),
        );
      }, 
    );
  }
}
