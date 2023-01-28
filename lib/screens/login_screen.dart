import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../services/authFunctions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Login'),
      ),
      body: login
          ?  Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Loggin In...")
            ],
          ) :
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 42.0, left: 8, right: 8, bottom: 8),
                child: TextFormField(
                  key: ValueKey(email),
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Email ID",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please Enter valid Email';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      email = value!.trim();
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  key: ValueKey(password),
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Password",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.length < 8) {
                      return 'Please Enter Password of min length 8';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.blue),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      login=true;
                      AuthServices.signinUser(email, password, context);
                    });
                  }
                },
                child: Text("Login"),
              ),
              SizedBox(
                height: 18,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: Text("SignUp"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
