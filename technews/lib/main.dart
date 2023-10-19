import 'package:flutter/material.dart';

import 'business_logic/blocs/stories_bloc_provider.dart';
import 'business_logic/blocs/comments_bloc_provider.dart';
import 'presentation/screens/news_list_screen.dart';
import 'presentation/screens/news_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    //Anytime our app starts up, it's gonna create a new
    //instance of the storiesBlocProvider which inturn
    //creates a new intance of our storiesBloc and make
    //it available to every widget inside our application
    return CommentsBlocProvider(
      child: StoriesBlocProvider(
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.white,
            fontFamily: 'Montserrat',
          ),
          title: 'News',
          //home: NewsListScreen(),
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  //Gets called each time a navigation event occurs
  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesBlocProvider.of(context);
          storiesBloc.fetchTopIds();
          return NewsListScreen();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsBlocProvider.of(context);
          //Retrieve an integer from this string
          final itemId = int.parse(settings.name!.replaceFirst('/', ''));
          commentsBloc.fetchItemWithComments(itemId); 
          return NewsDetailScreen(
            itemId: itemId,
          );
        },
      );
    }
  }
}
