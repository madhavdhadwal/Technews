import 'package:flutter/material.dart';

class loadingListTile extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: buildLoadingAnimation(context),
        subtitle: buildLoadingAnimation(context),
      ),
      Divider(
        height: 8.0,
      ),
    ]);
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