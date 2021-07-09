import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/mainscreen.dart';

class HistoryScreen extends StatefulWidget {
  final User user;

  const HistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _titlecenter = "Opps! No History.";
  List _cartList;
  double _totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMyHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(
                          user: widget.user,
                        )));
          },
        ),
        title: Text('Order History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteHistoryDialog();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            if (_cartList == null)
              Flexible(child: Center(child: Text(_titlecenter)))
            else
              Flexible(
                  child: OrientationBuilder(builder: (context, orientation) {
                return GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 5 / 2,
                    children: List.generate(_cartList.length, (index) {
                      return Padding(
                          padding: EdgeInsets.all(1),
                          child: Container(
                              child: Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.yellow[600],
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ]),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                                padding: EdgeInsets.all(2),
                                                height: orientation ==
                                                        Orientation.portrait
                                                    ? 100
                                                    : 150,
                                                width: orientation ==
                                                        Orientation.portrait
                                                    ? 100
                                                    : 150,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://crimsonwebs.com/s271738/bunplanet/images/${_cartList[index]['productId']}.png",
                                                )),
                                          ),
                                          Container(
                                              height: 100,
                                              child: VerticalDivider(
                                                  color: Colors.grey)),
                                          Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      _cartList[index]
                                                          ['productName'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Quantity : " +
                                                          _cartList[index]
                                                              ['cartqty']),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text("Status: Received"),
                                                  SizedBox(height: 5),
                                                  Text("Date Purchase: " +
                                                      _cartList[index]
                                                          ['datepurchase']),
                                                  MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    minWidth: 100,
                                                    height: 20,
                                                    child: Text(
                                                        'Delete History',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    color: Colors.brown,
                                                    onPressed: () {
                                                      _deleteoneHistoryDialog(
                                                          index);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))));
                    }));
              })),
          ],
        ),
      ),
    );
  }

  _loadMyHistory() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/orderhistory.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No item";
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];

        _titlecenter = "";
        _totalprice = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalprice = _totalprice +
              double.parse(_cartList[i]['price']) *
                  int.parse(_cartList[i]['cartqty']);
        }
      }
      setState(() {});
    });
  }

  void _deleteHistoryDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Are you sure to delete all history?',
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
                      _deleteHistory();
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

  void _deleteHistory() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/deletehistory.php"),
        body: {
          "email": widget.user.email,
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryScreen(
                      user: widget.user,
                    )));
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

  void _deleteoneHistoryDialog(index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Are you sure to delete this history?',
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
                      _deleteoneHistory(index);
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

  void _deleteoneHistory(index) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/deleteonehistory.php"),
        body: {
          "email": widget.user.email,
          "prid": _cartList[index]['productId'],
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryScreen(
                      user: widget.user,
                    )));
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
}
