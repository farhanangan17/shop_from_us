import 'dart:math';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode{
  Signup, Login
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0,1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      transform: Matrix4.rotationZ(-8 * pi/180)..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ]
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width>600 ?2 :1,
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
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  // Animation<Size> _heightAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    // _heightAnimation = Tween<Size>(
    //   begin: Size(double.infinity, 260),
    //   end: Size(double.infinity, 320)
    // ).animate(
    //   CurvedAnimation(
    //     parent: _controller,
    //     curve: Curves.easeIn
    //   )
    // );
    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      )
    );
    _slideAnimation = Tween<Offset>(
        begin: Offset(0, -1.5),
        end: Offset(0, 0),
    ).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.easeIn
        )
    );
    // _heightAnimation.addListener(() => setState((){}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message){
    showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'),
                )
              ],
            )
    );
  }

  Future<void> _submit() async{
    if(!_formKey.currentState.validate()){
      return ;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try{
      if(_authMode == AuthMode.Login){
        await Provider.of<Auth>(context, listen: false).login(_authData['email'], _authData['password']);
      }else{
        await Provider.of<Auth>(context, listen: false).signup(_authData['email'], _authData['password']);
      }

    } on HttpException catch(error){
    //  if failed validation of database
      print(error);
      var errorMessage = 'Authentication failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage = 'This email address already exists';
      }else if(error.toString().contains('INVALID_EMAIL')){
        errorMessage = 'Invalid email address';
      }else if(error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage = 'Could not find the user';
      }
      else if(error.toString().contains('INVALID_PASSWORD')){
        errorMessage = 'Invalid Password';
      }
      _showErrorDialog(errorMessage);
    } catch(error){
      const errorMessage = 'Could not authenticate you. Please try again later';
      // _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode(){
    if(_authMode == AuthMode.Login){
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    }else{
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      elevation: 8.0,
      //when animatedContainer is used AnimationController and Animation<Size> is not needed.
      child: AnimatedContainer(
      // AnimatedBuilder(
      //   animation: _heightAnimation,
      //   builder: (ctx, ch) => Container(
        duration: Duration(milliseconds: 300),
          height: _authMode == AuthMode.Signup ?320 :260,
          // height: _heightAnimation.value.height,
          constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.Signup ?320 :260
            // minHeight: _heightAnimation.value.height,
          ),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16),
        //   child: ch,
        // ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value.isEmpty || !value.contains('@')){
                      return 'Invalid email';
                    }
                  },
                  onSaved: (value){
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  //for not to show password
                  obscureText: true,
                  controller: _passwordController,
                  // keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value.isEmpty || value.length < 5){
                      return 'Too short';
                    }
                  },
                  onSaved: (value){
                    _authData['password'] = value;
                  },
                ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup? 60: 0,
                      maxHeight: _authMode == AuthMode.Signup? 120: 0
                    ),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                            ? (value){
                                if(value != _passwordController.text){
                                  return 'Password do not match';
                                }
                            }
                            : null,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20,),
                if(_isLoading) CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                  FlatButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
