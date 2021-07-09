import 'dart:convert';
import 'package:bunplanet/view/seller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/sellerdrawer.dart';

class Order2Screen extends StatefulWidget {
  final Seller seller;
  final User user;
  const Order2Screen({Key key, this.seller, this.user}) : super(key: key);

  @override
  _Order2ScreenState createState() => _Order2ScreenState();
}

class _Order2ScreenState extends State<Order2Screen> {
  List _productList = [];
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy');
  int cartitem = 0;
  String _titlecenter = "Opps! No Pick Up Order.";

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Orders"),
      ),
      drawer: MySellerDrawer(seller: widget.seller, user: widget.user),
      body: Center(
        child: Column(children: [
          Flexible(
              flex: 9,
              child: ListView.builder(
                  itemCount: _productList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.yellow[600],
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ]),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            width: 150.0,
                                            height: 150.0,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://crimsonwebs.com/s271738/bunplanet/images/${_productList[index]['productId']}.png",
                                            )),
                                      ),
                                      Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 5, 0),
                                                      child: Text(
                                                          "Order id: " +
                                                              _productList[
                                                                      index]
                                                                  ['orderid'],
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          textAlign: TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15)),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 5, 0),
                                                      child: Text(
                                                        "Bun Name: " +
                                                            _productList[index]
                                                                ['productName'],
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 5, 0),
                                                      child: Text(
                                                        "Quantity: " +
                                                            _productList[index]
                                                                ['cartqty'],
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 5, 0),
                                                      child: Text(
                                                        "Pick Up Time: " +
                                                            _productList[index]
                                                                ['pickuptime'],
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ])
                                            ],
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(Icons.check_box_rounded),
                                            onPressed: () =>
                                                {_deleteOrderDialog(index)},
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ));
                  })),
        ]),
      ),
    );
  }

  _loadOrder() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/loadorder2.php"),
        body: {"email": widget.seller.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _productList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["cart"];
        _titlecenter = "";
      }
      setState(() {});
    });
  }

  void _deleteOrder(int index) {
    String orderid = _productList[index]['orderid'];
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/deleteorder2.php"),
        body: {
          "orderid": orderid,
          "prid": _productList[index]['productId'],
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) =>
                    Order2Screen(seller: widget.seller, user: widget.user)));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _deleteOrderDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Order Done?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes",
                        style: TextStyle(color: Colors.yellow[600])),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deleteOrder(index);
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
