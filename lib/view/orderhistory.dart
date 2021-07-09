import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/sellerscreen.dart';
import 'package:bunplanet/view/seller.dart';
import 'package:intl/intl.dart';

class History2Screen extends StatefulWidget {
  final User user;
  final Seller seller;

  const History2Screen({Key key, this.user, this.seller, double total})
      : super(key: key);

  @override
  _History2ScreenState createState() => _History2ScreenState();
}

class _History2ScreenState extends State<History2Screen> {
  String _titlecenter = "Opps! No Order History.";
  List _cartList;
  double _totalprice = 0.0;
  final now = new DateTime.now();
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
                    builder: (context) => SellerScreen(
                          seller: widget.seller,
                          user: widget.user,
                        )));
          },
        ),
        title: Text('Order History'),
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
                                                          color:
                                                              Colors.blue[600],
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          "Quantity : " +
                                                              _cartList[index]
                                                                  ['cartqty'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      "Date Order: " +
                                                          _cartList[index]
                                                              ['dateorder'],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.green[600],
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "RM " +
                                                        (int.parse(_cartList[
                                                                        index][
                                                                    'cartqty']) *
                                                                double.parse(
                                                                    _cartList[
                                                                            index]
                                                                        [
                                                                        'price']))
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))));
                    }));
              })),
            Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 5),
                    Divider(
                      color: Colors.black,
                      height: 1,
                      thickness: 1.0,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "TOTAL RM " + _totalprice.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minWidth: 50,
                      height: 35,
                      child: Text('Save Sales',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                      color: Colors.yellow[600],
                      onPressed: () {
                        _savesalesDialog();
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _loadMyHistory() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/loadorderhistory.php"),
        body: {"email": widget.seller.email}).then((response) {
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

  _savesalesDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Are you sure to save this sales? You can only save once for per day.Please save after operating hours',
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
                      _savesales();
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

  void _savesales() {
    String _date = DateFormat('dd/MM/yyyy').format(now);
    double total = _totalprice;
    String total2 = total.toString();
    http.post(
        Uri.parse("https://crimsonwebs.com/s271738/bunplanet/php/sales.php"),
        body: {
          "date": _date,
          "sales": total2,
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
                builder: (context) =>
                    History2Screen(user: widget.user, seller: widget.seller)));
        return;
      } else {
        showDialog(
            builder: (context) => new AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    title: new Text(
                      'You are not able to save any sales for today, please save it tomorrow',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          child: Text("ok",
                              style: TextStyle(color: Colors.yellow[600])),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ]),
            context: context);
      }
    });
  }
}
