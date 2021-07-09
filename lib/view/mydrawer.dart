import 'package:bunplanet/view/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/myprofile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bunplanet/view/trackingscreen.dart';
import 'package:bunplanet/view/history.dart';
import 'package:bunplanet/view/sellerlogin.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({Key key, this.user}) : super(key: key);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountEmail: Text(widget.user.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.white
                    : Colors.red,
            backgroundImage: AssetImage(
              "assets/images/user.png",
            ),
          ),
          accountName: Text(widget.user.name),
        ),
        ListTile(
            title: Text("My Profile"),
            trailing: Icon(Icons.admin_panel_settings),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProfile(user: widget.user)));
            }),
        ListTile(
            title: Text("Chat With Seller"),
            trailing: Icon(Icons.chat_outlined),
            onTap: () {
              launchWhatsapp(
                  number: "+60172828151", message: "Hi Bun Planet! I am");
            }),
        ListTile(
            title: Text("Order Tracking"),
            trailing: Icon(Icons.departure_board_rounded),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => TrackingScreen(user: widget.user)));
            }),
        ListTile(
            title: Text("Order History"),
            trailing: Icon(Icons.history),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoryScreen(user: widget.user)));
            }),
        ListTile(
            title: Text("I am seller"),
            trailing: Icon(Icons.verified_user_rounded),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SellerLoginScreen(user: widget.user)));
            }),
        ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              _logoutDialog();
            })
      ],
    ));
  }

  void launchWhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("Can't open Whatsapp");
  }

  void _logoutDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Are you sure to logout?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes",
                        style: TextStyle(color: Colors.yellow[600])),
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                  TextButton(
                      child: Text("No",
                          style: TextStyle(color: Colors.yellow[600])),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }
}
