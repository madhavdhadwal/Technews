import 'package:flutter/material.dart';

//anyone who imports stories_bloc_provider file is also
//going to get access to both StoriesBlocProvider as well
//as StoriesBloc

import 'stories_bloc.dart';
export 'stories_bloc.dart';

//We make use of an inherited widget that allows us to kind of
//reach up the context at any point of our build hierarchy
//and get an instance of our StoriesBlocProvider, which then
//gives us the access to StoriesBloc

class StoriesBlocProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesBlocProvider({Key? key, Widget? child})
      : bloc = StoriesBloc(),
        super(key: key, child: child!);

  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StoriesBlocProvider>()!
        .bloc;
  }
}
