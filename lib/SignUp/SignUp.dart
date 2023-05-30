import 'package:assignment/utils/SessionController.dart';
import 'package:assignment/utils/TasksDbHelper.dart';
import 'package:assignment/utils/utils.dart';
import 'package:assignment/widgets/round_button.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool passwordVisible = true;
  bool confrmPassvisible = true;
  // final _auth = FirebaseAuth.instance;
  // final databaseRef = FirebaseDatabase.instance.ref('User');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUp() async {
    TasksDb db = TasksDb.instance;

    bool isinserted = await db.insertUser({
      'email': emailController.text.toString().toLowerCase(),
      'password': passwordController.text.toString(),
      'name': nameController.text.toString()
    });

    if (isinserted) {
      showDialogue();
    } else {
      Utils().toastErrorMessage("Error occured");
    }
  }

  showDialogue() {
    showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: SingleChildScrollView(
                child: Column(
              children: [const Text("Account Created")],
            )),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              child: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: confrmPassvisible,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  confrmPassvisible = !confrmPassvisible;
                                });
                              },
                              child: Icon(confrmPassvisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Confirm password';
                          } else if (value.toString() !=
                              passwordController.text) {
                            return 'Password And Confirm Password Not Match';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                title: 'Sign up',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      signUp();
                    } catch (e) {
                      // Utils().toastMessage("Error in User Creation");
                    }
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
