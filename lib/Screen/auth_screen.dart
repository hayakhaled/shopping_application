import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shop_app/Model/HttpE.dart';
import '../Model/HttpE.dart';
import 'package:shop_app/provider/auth.dart';

enum AuthMode { SignUp, LogIn }

class AuthScreen extends StatelessWidget {
  static const routName = '/auth';

  @override
  Widget build(BuildContext context) {
    final devicesSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(210,211,211,211).withOpacity(0.5),
                Color.fromARGB(210,26, 82, 118   ).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),
          SingleChildScrollView(
            child: Container(
              height: devicesSize.height,
              width: devicesSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 40),
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      'assets/images/shopping-cart.png',
                      height: 100,
                      width: 80,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 80),
                      transform: Matrix4.rotationZ(-10.0 * pi / 180.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent.shade100,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Text(
                        'My Shop',
                        style: TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: devicesSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthCard();
  }
}

class _AuthCard extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();
  AuthMode _authMode = AuthMode.LogIn;
  Map<String, String> _authData = {'email': '', 'password': ''};
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<double> opecityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =AnimationController(vsync:this , duration:Duration(milliseconds:300));

    opecityAnimation =Tween(begin:0.0, end:1.0).animate(
      CurvedAnimation(parent:_controller, curve:Curves.easeIn)
    );
//    _hiehAnimatio.addListener(() {setState(() {
//
//    });});
}

@override
  void dispose() {
    // TODO: implement dispose
  _controller.dispose();
    super.dispose();
  }
  void _showErrorDialo(String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('An Error Occurred !'),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.LogIn) {
// to log in
        await Provider.of<auth>(context,listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
// to sign up
        await Provider.of<auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);

      }
      Navigator.of(context).pushReplacementNamed('/productScreen');
    }

    on HttpExeption catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use .';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'this is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
        _showErrorDialo(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate.Please try again later.';
      _showErrorDialo(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
//    Navigator.of(context).pushReplacementNamed('/productScreen');
  }

  void _switchMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child:AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _authMode ==AuthMode.SignUp ? 320 :260,
        constraints:
        BoxConstraints(minHeight:_authMode ==AuthMode.SignUp ? 320 :260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(17),
        child: Form(
    key: _formkey,
    child: SingleChildScrollView(
    child: Column(
    children: [
    TextFormField(
    decoration: InputDecoration(labelText: 'E-Mail',
      labelStyle:TextStyle(color: Colors.grey),

      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue),

      ),
    ),

//      border: UnderlineInputBorder(borderSide:BorderSide(color: Colors.orange)
    keyboardType: TextInputType.emailAddress,
    // ignore: missing_return
    validator: (value) {
    if (value.isEmpty || !value.contains('@')) {
    return 'Invalid email!';
    }
    },
    onSaved: (value) {
    _authData['email'] = value;
    },
    ),
    TextFormField(
    decoration: InputDecoration(labelText: 'Password',
      labelStyle:TextStyle(color: Colors.grey),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue),

    ),
    ),

    // ignore: missing_return
    controller: _passwordController,
    validator: (value) {
    if (value.isEmpty) {
    return 'Please enter your password you want';
    }
    },
    onSaved: (value) {
    _authData['password'] = value;
    },
    obscureText: true,
    ),
    if (_authMode == AuthMode.SignUp)
    AnimatedContainer(
      constraints: BoxConstraints(minHeight:_authMode ==AuthMode.SignUp ?60 : 0, maxHeight:_authMode ==AuthMode.SignUp?120 :0),
    duration:Duration(milliseconds: 200),
    curve:Curves.easeIn,
      child: FadeTransition(
        opacity:opecityAnimation,
        child: TextFormField(
        enabled: _authMode == AuthMode.SignUp,
        decoration: InputDecoration(
        labelText: 'Confirm password',
          labelStyle:TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue),

          ),
        ),

        obscureText: true,
        // ignore: missing_return
        validator: _authMode == AuthMode.SignUp
        ? (value) {
        // ignore: missing_return
        if (value != _passwordController.text) {
        return 'password do not match!';
        }
        }
            : null,
        ),
      ),
    ),
    SizedBox(
    height: 20,
    ),
    if (_isLoading)
    CircularProgressIndicator(backgroundColor:Colors.lightBlueAccent,)
    else
    RaisedButton(
    child:
    Text(_authMode == AuthMode.LogIn ? 'LOGIN' : 'SIGN UP'),
    onPressed: _submit,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    padding:
    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
    color: Colors.blueAccent.shade100,
    ),
    FlatButton(
    child: Text(
    '${_authMode == AuthMode.LogIn ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
    onPressed: _switchMode,
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textColor: Colors.blueAccent.shade100,
    )
    ],
    ),
    ),
    ),)
    );
  }
}
