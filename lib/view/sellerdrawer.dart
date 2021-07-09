
import 'package:flutter/material.dart';
import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/seller.dart';
import 'package:bunplanet/view/orderhistory.dart';

import 'package:bunplanet/view/mainscreen.dart';
import 'package:bunplanet/view/pickuporder.dart';
import 'package:bunplanet/view/sales.dart';
import 'package:bunplanet/view/orderdetails.dart';

class MySellerDrawer extends StatefulWidget {
  final Seller seller;
  final User user;
  

  const MySellerDrawer({Key key, this.seller, this.user}) : super(key: key);
  @override
  _MySellerDrawerState createState() => _MySellerDrawerState();
}

class _MySellerDrawerState extends State<MySellerDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
           accountEmail: Text(widget.seller.email),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.white
                    : Colors.red,
            backgroundImage: AssetImage(
              "assets/images/seller.jpg",
            ),
          ),
           accountName: Text('Seller'),
        ),
        
        
            ListTile(
            title: Text("Delivery Order"),
            trailing: Icon(Icons.departure_board_rounded),
            onTap: () {
               Navigator.push(context,
            MaterialPageRoute(builder: (content) => OrderScreen(seller:widget.seller,user:widget.user)));
            }),
            ListTile(
            title: Text("Pickup Order"),
            trailing: Icon(Icons.directions_walk_rounded),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Order2Screen(seller:widget.seller,user:widget.user)));
            }),
              ListTile(
            title: Text("Order History"),
            trailing: Icon(Icons.history),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => History2Screen(seller:widget.seller,user:widget.user)));
            }),
            ListTile(
            title: Text("Sales"),
            trailing: Icon(Icons.attach_money_rounded),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SalesScreen(seller:widget.seller,user:widget.user)));
            }),
        ListTile(
            title: Text("Back to main"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              _backtomainDialog();
            })
      ],
    ));
  }
  
  void _backtomainDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Are you sure to back and leave?',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes", style: TextStyle(
                              color: Colors.yellow[600])),
                    onPressed: () async {
                       Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(user:widget.user
                                ),
                          ),
                        );
                    },
                  ),
                  TextButton(
                     child: Text("No", style: TextStyle(
                              color: Colors.yellow[600])),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
        context: context);
  }

} 