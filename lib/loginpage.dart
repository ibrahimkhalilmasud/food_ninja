import 'package:flutter/material.dart';
import 'package:food_ninja/registeruser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
// ignore: unused_import
import 'package:progress_dialog/progress_dialog.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  bool _rememberMe = false;
  String _email = "";
  String _password = "";
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: new Container(
        padding: EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/foodninjared.png',
                  scale: 2.5,
                ),
                TextField(
                  controller: _emcontroller,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _pscontroller,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: _rememberMe,
                        onChanged: (bool value) {
                          // _onChange(value);
                        }),
                    Text("Remember Me", style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Login'),
                  color: Colors.black,
                  textColor: Colors.white,
                  elevation: 15,
                  onPressed: _onLogin,
                ),
                // RaisedButton(child: Text('Login'), onPressed: null),
                SizedBox(height: 20),
                //Text("Register new Account"),
                GestureDetector(
                  onTap: _onRegister,
                  child: Text("Register New Account",
                      style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 10),
                // Text("Forgot Password"),
                GestureDetector(
                  onTap: null, // _onForgot,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post(
        "https://foodloverv3.000webhostapp.com/foodninjav2/php/login_user.php",
        body: {
          "email": _email,
          "password": _password,
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Login Succes",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        // Navigator.push(context,
        // MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterUser()));
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;
        Toast.show(
          "Email/password empty!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
      Toast.show(
        "Preferences removed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }
}
