import 'dart:convert';
import 'dart:io';

import 'package:contactus/contactus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homelyy/Screens/UserProfile/contactus.dart';
import 'package:homelyy/Screens/UserProfile/wallet.dart';
import 'package:homelyy/Screens/login/loginScreen.dart';
import 'package:homelyy/Screens/orders/orderpage.dart';
import 'package:homelyy/component/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/api.dart';
import '../../component/models.dart';

class UserProfile extends StatefulWidget {
  final String id;

  const UserProfile({Key key, this.id}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Text("User Name"),
            //     TextButton(onPressed: () {}, child: Text("EDIT"))
            //   ],
            // ),

            buildListTile("MY ORDERS", FontAwesomeIcons.list, () {
              Get.to(
                  OrderPage(
                  ref: widget.id,
              )
              );
            }
            ),
            buildListTile("WALLET", FontAwesomeIcons.wallet, () {

              Get.to(UserWallet(id: widget.id,));

            }
            ),
            buildListTile("REFER & EARN", FontAwesomeIcons.share, () async {
             var value = await AllApi()
                  .getUser(widget.id
                  .replaceAll("+", "")
                  .removeAllWhitespace);

              UserModel users =
              UserModel().fromJson(jsonDecode(value));
              if(GetPlatform.isAndroid){
                await FlutterShare.share(
                    title: 'Download Homelyy App Referal Code: ${users.referid} Get upto 5% Cashback on Every Order',
                    text: 'Download Homelyy App Referal Code:  ${users.referid} Get upto 5% Cashback on Every Order',
                    linkUrl: 'https://play.google.com/store/apps/details?id=com.an.homelyy.homelyy',
                    chooserTitle: 'Example Chooser Title'
                );
              }else{

              }

            }),
            buildListTile("CONTACT US", FontAwesomeIcons.phone, () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyContactUs())
              );
            }),
            Divider(),
            buildListTile("LOGOUT", FontAwesomeIcons.doorClosed, () async {
              // FirebaseAuth.instance
              //     .signOut()
              //     .then((value) => Navigator.pushAndRemoveUntil<dynamic>(
              //           context,
              //           MaterialPageRoute(builder: (context) => LoginScreen()),
              //           (route) =>
              //               false, //if you want to disable back feature set to false
              //         ));
               SharedPreferences pref =  await SharedPreferences.getInstance();
               pref.clear();
               Get.offAll(LoginScreen());
            }),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(var title, var icon, var press) => ListTile(
    trailing: Icon(FontAwesomeIcons.arrowRight),
    title: Text(title),
    leading: Icon(icon),
    onTap: press,
  );
}
