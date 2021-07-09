import 'package:flutter/material.dart';
import 'package:bunplanet/view/user.dart';
import 'loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:bunplanet/view/loginscreen.dart';
import 'package:bunplanet/view/mainscreen.dart';

class MyProfile extends StatefulWidget {
  final User user;

  const MyProfile({Key key, this.user}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double screenHeight, screenWidth;
  ProgressDialog pr;
  bool _obscureText = true;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordControllera = new TextEditingController();
  TextEditingController _passwordControllerb = new TextEditingController();
  TextEditingController _passwordControllerc = new TextEditingController();
  TextEditingController _phonenumController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => MainScreen(
                            user: widget.user,
                          )));
            },
          ),
          title: Text('My Profile'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(100, 50, 100, 10),
                  child: Image.asset('assets/images/user.png', scale: 2),
                ),
                Text((widget.user.name),
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Text(widget.user.email),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(children: [
                      SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Enter New Name",
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _phonenumController,
                        decoration: InputDecoration(
                          hintText: "Enter New Phone Number",
                          hintStyle: TextStyle(fontSize: 15),
                          labelText: (widget.user.phonenum),
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minWidth: 200,
                        height: 35,
                        child: Text('Save Profile',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.brown,
                        onPressed: _onSaveProfile,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordControllera,
                        decoration: InputDecoration(
                          labelText: "Current Password",
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: _togglePass,
                            child: Icon(Icons.visibility),
                          ),
                        ),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordControllerb,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: _togglePass,
                            child: Icon(Icons.visibility),
                          ),
                        ),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordControllerc,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: _togglePass,
                            child: Icon(Icons.visibility),
                          ),
                        ),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minWidth: 200,
                        height: 35,
                        child: Text('Save Password',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.brown,
                        onPressed: _onSavePassword,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _onSaveProfile() {
    String _username = _usernameController.text.toString();
    String _phonenum = _phonenumController.text.toString();
    if (_username.isEmpty || _phonenum.isEmpty) {
      Fluttertoast.showToast(
        msg:
            "Could't left any field blanked. If no changes either one, please fill in the same data. ",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Change Profile"),
            content: Text("Are your sure to save your changes?"),
            actions: [
              TextButton(
                child: Text("Ok", style: TextStyle(color: Colors.yellow[600])),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onSaveProfileEdit(_username, _phonenum);
                },
              ),
              TextButton(
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.yellow[600])),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _onSavePassword() {
    String _passworda = _passwordControllera.text.toString();
    String _passwordb = _passwordControllerb.text.toString();
    String _passwordc = _passwordControllerc.text.toString();

    if (_passwordb.isEmpty || _passworda.isEmpty) {
      Fluttertoast.showToast(
        msg: "Could't left any field blanked ",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    if (_passwordb != _passwordc) {
      Fluttertoast.showToast(
          msg: "Please use the same password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    if (_passworda.length < 5) {
      Fluttertoast.showToast(
          msg: "Password should atleast 5 characters long ",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Change Password"),
            content: Text("Are your sure to save your changes?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onSavePasswordEdit(_passworda, _passwordb);
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.hasMatch(value));
    return regExp.hasMatch(value);
  }

  void _onSaveProfileEdit(String _username, String _phonenum) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/updateprofile.php"),
        body: {
          "email": widget.user.email,
          "newusername": _username,
          "newphonenum": _phonenum
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
  }

  void _onSavePasswordEdit(String _passworda, String _passwordb) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s271738/bunplanet/php/updatepassword.php"),
        body: {
          "email": widget.user.email,
          "password": _passworda,
          "newpassword": _passwordb
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
  }

  void _togglePass() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
