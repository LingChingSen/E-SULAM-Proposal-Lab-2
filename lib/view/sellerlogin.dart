import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:bunplanet/view/user.dart';
import 'package:bunplanet/view/seller.dart';
import 'package:bunplanet/view/sellerscreen.dart';
import 'package:bunplanet/view/mainscreen.dart';

class SellerLoginScreen extends StatefulWidget {
  final User user;
  final Seller seller;
  const SellerLoginScreen({Key key, this.user, this.seller}) : super(key: key);
  @override
  _SellerLoginScreenState createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends State<SellerLoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences prefs;
  double screenHeight, screenWidth;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Logingin...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MainScreen(user: widget.user, seller: widget.seller)));
          },
        ),
        title: Text('Seller Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(100, 50, 100, 10),
                child: Image.asset('assets/images/bunplanet.png', scale: 2),
              ),
              SizedBox(height: 3),
              Container(
                margin: EdgeInsets.fromLTRB(70, 50, 70, 10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueGrey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Seller Code', icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      minWidth: 200,
                      height: 35,
                      child:
                          Text('Login', style: TextStyle(color: Colors.white)),
                      color: Colors.brown,
                      onPressed: _onLogin,
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    if (_email.isEmpty || _password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Could't left email or password empty! ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      pr = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
      await pr.show();

      http.post(
          Uri.parse(
              "https://crimsonwebs.com/s271738/bunplanet/php/sellerlogin.php"),
          body: {"email": _email, "code": _password}).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Login Fail",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);

          pr.hide().then((isHidden) {
            print(isHidden);
          });
        } else {
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          Seller seller = Seller(
            email: _email,
            code: _password,
          );
          pr.hide().then((isHidden) {
            print(isHidden);
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) =>
                      SellerScreen(seller: seller, user: widget.user)));
        }
      });
    }
  }

  
}
