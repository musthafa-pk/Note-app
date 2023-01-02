import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noteappwithfirebase/Views/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool taped = false;

  setpref() async {
    final prefrence = await SharedPreferences.getInstance();
    await prefrence.setString('email', email.text);
    await prefrence.setString('password', password.text);
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController regname = TextEditingController();
  // TextEditingController regpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 227, 182, 1),
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: taped == false
            ? Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back...',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      Container(
                          decoration: BoxDecoration(color: Colors.pink),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 3, bottom: 3),
                            child: Text(
                              'Keep Safe Your Memos',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                      SizedBox(height: MediaQuery.of(context).size.height / 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: TextField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'User Name or Email',
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: TextField(
                                  controller: password,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                      suffixIcon: Icon(
                                        Icons.remove_red_eye_outlined,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () async {
                            try {
                              var user = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text, password: password.text);
                              setpref();
                            } catch (e) {
                              print(e);
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ));
                          },
                          color: Colors.green,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an account?',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              taped = true;
                              print(taped);
                            });
                          },
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            :
            //signup page--------------------------------------
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome!..',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Lottie.asset('asset/87845-hello.json'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'User Name or Email',
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: TextField(
                                controller: password,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    suffixIcon: Icon(
                                      Icons.remove_red_eye_outlined,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              var user = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email.text, password: password.text);
                              setpref();
                            } catch (e) {
                              print(e);
                              if (e.toString().contains('abcd')) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'The password is invalid or the user doesnot have password')));
                              }
                            }
                          },
                          child: Text('Sign Up')),
                    ),]),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  taped = false;
                                });
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              ],
            ),
      ),
    );
  }
}
