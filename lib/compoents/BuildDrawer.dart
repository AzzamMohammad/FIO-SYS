import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/create_group/create_group_screen.dart';
import '../single_api/change_file_number/change_file_number_screen.dart';
import '../single_api/change_port/chang_port_screen.dart';
import '../single_api/logout/logout_screen.dart';

Widget BuildDrawer(BuildContext context){
  return Drawer(
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height *.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight:Radius.circular(5) ),
              gradient: LinearGradient(
                  colors: [
                    Color(0xffB73E3E),
                    Color(0xffDD5353),
                    Color(0xffe78383)
                  ]
              )
          ),
          child: Center(
            child: Text('FIO SYS',style: TextStyle(fontSize: 30,color: Color(0xffDBC8AC)),),
          ),
        ),
        Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildDrawerListItem(context,Icons.home,'Home',(){Get.offNamed('/home');}),
                BuildDrawerListItem(context,Icons.groups,'User groups',(){Get.offNamed('/all_group_for_user');}),
                BuildDrawerListItem(context,Icons.group_add_sharp,'Add group',(){BuildAddGroupBar(context);}),
                Padding(
                  padding:  EdgeInsets.only(left: 8,right: 8),
                  child: Divider(thickness: 2,),
                ),
                Center(
                  child: Text('Admin',style: TextStyle(color: Color(0xffB73E3E)),),
                ),
                BuildDrawerListItem(context,Icons.group_sharp,'System groups',(){Get.offNamed('/all_groups_in_sys');}),
                BuildDrawerListItem(context,Icons.file_copy_rounded,'System groups',(){Get.offNamed('/all_files_in_sys');}),
                BuildDrawerListItem(context,Icons.cast_connected,'Chang PUSHER APP ID',(){BuildChangePort(context);}),
                BuildDrawerListItem(context,Icons.account_box,'Chang number files',(){BuildFileNumber(context);}),
                BuildDrawerListItem(context,Icons.logout,'Logout',(){BuildLogoutBar(context);}),

                // BuildDrawerListItem(context),
                  // BuildDrawerListItem(context),
                  // BuildDrawerListItem(context),
                  // BuildDrawerListItem(context),
              ],
            ),
        )
      ],
    ),
  );
}

Widget BuildDrawerListItem(BuildContext context,IconData ListTileIcon ,String Title ,void Function()? OnTap){
  return GestureDetector(
    onTap: (){
      OnTap!();
    },
    child: ListTile(
      leading: Icon(ListTileIcon,size: 30,),
      title: Text(Title,style: TextStyle(fontSize: 15),),
    ),
  );
}


