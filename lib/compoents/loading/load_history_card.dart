import 'package:flutter/material.dart';

import 'loading_item.dart';

Widget LoadHistoryCard(BuildContext context){
  return Padding(
    padding:  EdgeInsets.only(top: 8.0),
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(15),),
        color: Color(0xffDBC8AC),
      ),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingListItem.Square(
            width: MediaQuery.of(context).size.width * .7,
            height: 12,
            radius: 10,
            color: Color(0xffDD5353),
          ),
          SizedBox(height: 27,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .4,
                child:LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: 9,
                  radius: 10,
                  color: Colors.black,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .12,
                child: LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .09,
                  height: 9,
                  radius: 10,
                  color: Colors.black,
                ),
              ),
              Container(
                // padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width *.3 ,
                child: LoadingListItem.Square(
                  width: MediaQuery.of(context).size.width * .3,
                  height: 9,
                  radius: 10,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}