import 'package:flutter/material.dart';

import '../../business_logic/blocs/stories_bloc_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;
  Refresh({required this.child});

  Future<void> refreshScreen(StoriesBloc bloc) async {
    await bloc.clearCache();
    await bloc.fetchTopIds();
  }

  Widget build(BuildContext context) {
    final bloc = StoriesBlocProvider.of(context);
    return RefreshIndicator(child: child, onRefresh: () => refreshScreen(bloc));
  }
}
