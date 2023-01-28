import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/screens/upload_img.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../services/authFunctions.dart';
import 'home_screen.dart';
bool isImgUpload=false;
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  bool visible = false;

  TextEditingController email_controller = TextEditingController();
  TextEditingController pass_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();
  TextEditingController college_controller = TextEditingController();
  TextEditingController year_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  bool isPassValid = false;

  String email = '';
  String password = '';
  String fullname = '';
  String mobile = '';
  String college = '';
  String year = '';
  bool login = false;
  bool isLoading = false;
  
  bool validateEmailPass() {
    final bool isEmailValid =
        EmailValidator.validate(email_controller.text.trim());
    if (isEmailValid && isPassValid) {
      return true;
    } else {
      return false;
    }
  }

  List<String> list = <String>['Student', 'Faculty', 'Alumni'];
  late String dropdownValue = list.first;
  var role = "Student";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration")),
      body:
          // body: isLoading
          //     ?  Column(mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Center(
          //                   child: CircularProgressIndicator(
          //                     backgroundColor: Colors.green,
          //                     color: Colors.amber,
          //                   ),
          //                 ),
          //                 SizedBox(height: 10,),
          //                 Text("Registering User...")
          //       ],
          //     )
          //     :
          SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    width: 200,
                    child: Row(
                      children: [
                        Text("User Type: "),
                        DropdownButton<String>(
                          iconSize: 30,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 8,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          dropdownColor: Colors.blue,
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  color: Colors.amber,
                                  child: Text(
                                    "$value",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            setState(() {
                              dropdownValue = newValueSelected!;
                              role = newValueSelected;
                            });
                          },
                          value: dropdownValue,
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  key: ValueKey('email'),
                  controller: email_controller,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Email ID",
                      border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      email = value!.trim();
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  obscureText: true,
                  controller: pass_controller,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Password",
                      border: OutlineInputBorder()),
                  onSaved: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                ),
              ),
              FlutterPwValidator(
                controller: pass_controller,
                minLength: 8,
                uppercaseCharCount: 2,
                numericCharCount: 3,
                specialCharCount: 1,
                normalCharCount: 3,
                width: 400,
                height: 150,
                onSuccess: () {
                  setState(() {
                    isPassValid = true;
                  });
                },
                onFail: () {
                  setState(() {
                    isPassValid = false;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8),
                child: TextFormField(
                  key: ValueKey('mobile'),
                  controller: mobile_controller,
                  decoration: InputDecoration(
                      labelText: "Mobile",
                      hintText: "Enter Mobile Number",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Mobile Number cannot be empty';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      mobile = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  key: ValueKey('fullname'),
                  controller: name_controller,
                  decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "Enter Name",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Full Name';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      fullname = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  key: ValueKey('college'),
                  controller: college_controller,
                  decoration: InputDecoration(
                      labelText: "College Name",
                      hintText: "Enter College Name",
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'College Name cannot be empty';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      college = value!;
                    });
                  },
                ),
              ),
              if (dropdownValue == list[0] || dropdownValue == list[2]) ...[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    key: ValueKey('year'),
                    controller: year_controller,
                    decoration: InputDecoration(
                        labelText: dropdownValue == list[0]
                            ? "Admission Year"
                            : "Pass-out Year",
                        hintText: dropdownValue == list[0]
                            ? "Enter Admission Year"
                            : "Enter Pass-out Year",
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return dropdownValue == list[0]
                            ? "Admission Year cannot be empty"
                            : "Pass-out Year cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        year = value!;
                      });
                    },
                  ),
                ),
              ],
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/upload_img");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 300,
                    color: Colors.green,
                    child: Text("Upload Profile Picture"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 300,
                  color: Colors.green,
                  child: Text("Upload Resume (optional)"),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Align(
              //     alignment: Alignment.center,
              //     child: TextButton(
              //       style: TextButton.styleFrom(
              //           foregroundColor: Colors.black,
              //           backgroundColor: Colors.blue),
              //       onPressed: () async {
              //         if (_formKey.currentState!.validate() &&
              //             validateEmailPass()) {
              //           _formKey.currentState!.save();
              //           setState(() {
              //             isLoading = true;
              //             AuthServices.signupUser(
              //                 email, password, fullname, context);
              //           });
              //         } else {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(
              //                   content: Text("Invalid Credentials")));
              //         }
              //       },
              //       child: Text("Register"),
              //     ),
              //   ),
              // )
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                elevation: 5.0,
                height: 40,
                onPressed: () {
                  setState(() {
                    showProgress = true;
                  });
                  signUp(
                      email_controller.text,
                      pass_controller.text,
                      role,
                      name_controller.text,
                      college_controller.text,
                      dropdownValue==list[1] ?  year_controller.text : '0000');
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, String role, String name,
      String college, String year) async {
    CircularProgressIndicator();
    if (_formKey.currentState!.validate() && validateEmailPass()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) =>
              {postDetailsToFirestore(email, role, name, college, year)})
          .catchError((e) {
            ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
          });
    }
  }

  postDetailsToFirestore(String email, String role, String name, String college,
      String year) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users2');
    ref.doc(user!.uid).set({
      'email': email,
      'role': role,
      'name': name,
      'college': college,
      'year': year
    });
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => Home())));
  }
}
