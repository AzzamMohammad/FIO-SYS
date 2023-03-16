import 'package:flutter/material.dart';
import 'loading_item.dart';

Widget LoadingGroupCard(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(left: 8),
    width: MediaQuery.of(context).size.width,
    height: 100,
    child: ListTile(
      leading:LoadingListItem.Square(
        width: 40,
        height: 50,
        radius: 10,
        color: Color(0xffDD5353),
      ),
      title:    LoadingListItem.Square(
        width: MediaQuery.of(context).size.width * .6,
        height: 10,
        radius: 8,
        color: Color(0xffDD5353),
      ),
    ),
  );
}
