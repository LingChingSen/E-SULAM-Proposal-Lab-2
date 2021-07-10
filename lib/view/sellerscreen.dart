import 'dart:convert';

import 'package:bunplanet/view/seller.dart';
import 'package:http/http.dart' as http;
import 'newproduct.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/sellerdrawer.dart';

class SellerScreen extends StatefulWidget {
  final Seller seller;
  final User user;
 const SellerScreen({Key key, this.seller, this. user}) : super(key: key);

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  List _productList = [];
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy');
  TextEditingController _srcController = new TextEditingController();
  int cartitem = 0;

  @override
  void initState() {
    super.initState();
    _testasync();
    
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bun Planet"),
        
      ),
      drawer: MySellerDrawer(seller: widget.seller,user:widget.user),
      body: Center(
        child: Column(children: [
          Column(children: [
            TextFormField(
              controller: _srcController,
              decoration: InputDecoration(
                hintText: "Search Buns",
                suffixIcon: IconButton(
                  onPressed: () => _loadProducts(_srcController.text),
                  icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white24)),
              ),
            )
          ]),
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
                                            decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: new NetworkImage(
                                                        "https://crimsonwebs.com/s271738/bunplanet/images/${_productList[index]['id']}.png")))),
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
                                                          "Bun Name: " +
                                                              _productList[
                                                                      index]
                                                                  ['name'],
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
                                                        "Price: RM " +
                                                            _productList[index]
                                                                ['price'],
                                                        style: TextStyle(
                              color: Colors.red[600])
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 5, 0),
                                                      child: Text(
                                                        "Filling: " +
                                                            _productList[index]
                                                                ['type'],
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 15, 5, 0),
                                                      child: Text(
                                                        "Type of Bun: " +
                                                            _productList[index]
                                                                ['qty'],
                                                        style: TextStyle(
                              color: Colors.green[600])
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
                                            icon: Icon(Icons.delete_forever_rounded),
                                            onPressed: () =>
                                                { _deletePostDialog(index)},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewProduct(seller: widget.seller, user: widget.user)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _loadProducts(String prname) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/loadproduct.php"),
        body: {"prname": prname}).then((response) {
      if (response.body == "nodata") {
        Fluttertoast.showToast(
            msg: "No Buns Found!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.red,
            fontSize: 20.0);
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _productList = jsondata["products"];
       
      }
      setState(() {});
    });
  }

  Future<void> _testasync() async {
    _loadProducts("");
  }

  void _deletePost(int index) {
    String prid = _productList[index]['id'];
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/sellerdelete.php"),
        body: {
         
          "prid": prid
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
                    SellerScreen(seller: widget.seller, user: widget.user)));
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

   void _deletePostDialog(int index) {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Delete this product ?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes", style: TextStyle(
                              color: Colors.yellow[600])),
                    onPressed: () {
                      
                      _deletePost(index);
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
