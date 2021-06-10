import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:fluttertoast/fluttertoast.dart';
import'package:http/http.dart'as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'registrationscreen.dart';
import 'user.dart';
import 'package:bunplanet/view/mainscreen.dart';


class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState()=>_LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe= false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  SharedPreferences prefs;
    double screenHeight, screenWidth;
    ProgressDialog pr;
  
@override
void initState(){
  loadPref();
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
            body: Center(
              child: SingleChildScrollView(
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container( margin: EdgeInsets.fromLTRB(100,50,100,10),
                  child: Image.asset('assets/images/bunplanet.png',scale:2),),
                  SizedBox(height:3),
                  Text('Login',style:TextStyle(fontSize:25,fontWeight: FontWeight.bold)),
                  Container(
                   margin: EdgeInsets.fromLTRB(70,50,70,10),
                    decoration: BoxDecoration(
                     border: Border.all(
                       color : Colors.blueGrey,
                     ),
                     borderRadius: BorderRadius.all(Radius.circular(10))
                     ),

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,5,20,5),
                      child: Column(
                        children:[
                        TextField(controller:_emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',icon:Icon(Icons.email)),
                        ),
                        TextField(controller:_passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',icon:Icon(Icons.lock)),
                          obscureText: true,),
                          SizedBox(height:20),
                          Row(
                          children:[
                            Checkbox(value:_rememberMe, onChanged:(bool value){
                              _onChange(value);
                                                          }
                                                          ),
                                                          Text('Remember Me'),
                                                    ]
                                                    ),
                                                    MaterialButton(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                      minWidth:200,height:35,
                                                      child:Text('Login',style: TextStyle(color: Colors.white)),
                                                      color: Colors.brown,
                                                      onPressed: _onLogin,
                                                        )
                                                       ]
                                                            ),
                                                              ),
                                                      
                                                              ),
                                                               SizedBox(height:10),
                                                         GestureDetector(
                                                          child: Text("Forgot Password",style: TextStyle(fontSize:16)),onTap: _forgotPassword), 
                                                          SizedBox(height:10),
                                                                GestureDetector(
                                                                  child: Text("Register for New Account",style: TextStyle(fontSize:16 )),onTap: _regitrNewAccount),
                                                                                                                                                                                                                                                                 
                                                                 ],
                                                                ),
                                                                    ),
                                                                     ),
                                                                                                              
                                                                );
                                                             }
                                                              
                                                      
  
                                                                   
                                                        
                                                      
                                                                                                                                                                                                                              
                                              void _onChange(bool value) {
                                                   String _email = _emailController.text.toString();
                                                     String _password = _passwordController.text.toString();
                                                         if(_email.isEmpty || _password.isEmpty){
                                                            Fluttertoast.showToast(
                                                              msg:"Could't left email or password empty! ",
                                                             toastLength: Toast.LENGTH_SHORT,
                                                                gravity:ToastGravity.TOP,
                                                                  timeInSecForIosWeb: 1,
                                                                   backgroundColor:Colors.red,
                                                                     textColor:Colors.white,
                                                                     fontSize:16.0,
                                                      
                                                                       );
                                                         }
                                                                                    
                                                                setState(() {
                                                               _rememberMe = value;
                                                                storePref(value,_email,_password);
                                                                                                           });
                                                                                                       }
 Future<void> _onLogin() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    String _email = _emailController.text.toString();
    String _password = _passwordController.text.toString();
    http.post(
        Uri.parse("https://crimsonwebs.com/s271738/bunplanet/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
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
            List userdata = response.body.split(",");
        User user = User(
            email: _email,
            password: _password,
            name: userdata[1],
            phonenum: userdata[2],
            datereg: userdata[3],
            rating: userdata[4],
            credit: userdata[5],
            status: userdata[6]); 
            pr.hide().then((isHidden) {
          print(isHidden);
        });
          Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user)));
      }
    });
  }
                                                                                                                                                                                         
                                                                                                                                                                                                                                                             
                     void _regitrNewAccount() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen() ));                                         
                           }
                                                                                                                                                     
                                        void _forgotPassword() {
                                            TextEditingController _useremailcontroller = TextEditingController();
                                            showDialog(
                                             context: context,
                                             builder: (context){
                                             return AlertDialog(
                                             title: Text("Forgot Password?"),
                                            content: new Container(
                                             height: 100,
                                             child:Column(
                                               children:[
                                               Text("Enter your recovery email"),
                                                TextField(controller:_useremailcontroller,
                                                     decoration: InputDecoration(
                                                    labelText: 'Email',icon:Icon(Icons.email)
                                                 ))
                                              ],
                                                ),
                                            ),
                                                actions: [
                                                  TextButton(child: Text("Submit"),onPressed:(){
                                                      print(_useremailcontroller.text);
                                                          _resetPassword(_useremailcontroller.text);
                                                                                                                           
                                                              }),
                                                          TextButton(child: Text("Cancel"),onPressed:(){
                                                           Navigator.of(context).pop();
                                                              }),
                                                             ],
                                                              );
                                                               }
                                                                 );
                                                                 }
                   Future<void> storePref(bool value,String email, String password, ) async {
                           prefs = await SharedPreferences.getInstance();
                             if(value){
                              await prefs.setString("email",email);
                                 await prefs.setString("password",password);
                                await prefs.setBool("rememberme",value);
                                      Fluttertoast.showToast(
                                        msg:"Preferences stored ",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity:ToastGravity.TOP,
                                         timeInSecForIosWeb: 1,
                                         backgroundColor:Colors.red,
                                         textColor:Colors.white,
                                           fontSize:16.0,
                                            );
                                             return;
                                             }else{
                                                await prefs.setString("email",'');
                                                 await prefs.setString("password",'');
                                                  await prefs.setBool("rememberme",false); 
                                                   Fluttertoast.showToast(
                                                      msg:"Preferences removed",
                                                       toastLength: Toast.LENGTH_SHORT,
                                                        gravity:ToastGravity.TOP,
                                                          timeInSecForIosWeb: 1,
                                                            backgroundColor:Colors.red,
                                                            textColor:Colors.white,
                                                             fontSize:16.0,
                                                                                                                                   
                                                                 );
                                                                setState(() {
                                                                 _emailController.text = "";
                                                                    _passwordController.text = "";
                                                                       });
                                                                       }
                                                                        }


                    Future<void> loadPref() async {
                           prefs = await SharedPreferences.getInstance();
                              String _email = prefs.getString("email")??'';
                                String _password = prefs.getString("password")??'';
                                   _rememberMe = prefs.getBool("rememberme")??false;
                                                                                                 
                                      setState(() {
                                          _emailController.text = _email;
                                             _passwordController.text = _password;
                                                                                                 
                                                  });
                                                    }
                                                void _resetPassword(String emailreset) {
                                               http.post(
                                               Uri.parse("https://crimsonwebs.com/s271738/bunplanet/php/reset_user.php"),
                                                 body:{ "email":emailreset}).then((response){
                                                 print(response.body);
                                                                    if(response.body=="success"){
                                                                      Fluttertoast.showToast(
                                                                      msg:"Please check your email ",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity:ToastGravity.TOP,
                                                                      timeInSecForIosWeb: 1,
                                                                      backgroundColor:Colors.red,
                                                                      textColor:Colors.white,
                                                                      fontSize:16.0);
                                                                    }else{
                                                                     Fluttertoast.showToast(
                                                                      msg:"Failed ",
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity:ToastGravity.TOP,
                                                                      timeInSecForIosWeb: 1,
                                                                      backgroundColor:Colors.red,
                                                                      textColor:Colors.white,
                                                                      fontSize:16.0); 
                                                                    
                                                  }
    });
  }
                                              


                                                                                                 
                                             
                                              
                                              
                                                                    
                                                      
  


                                             

              
                                             
              
   
}