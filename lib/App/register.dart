import 'package:flutter/material.dart';
import 'package:jualan/App/login.dart';
import 'package:jualan/App/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    );
  }
}

class Register extends StatelessWidget{
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Image.asset('assets/images/toplog.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fill,),
            const Text(
              'Sign Up', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'Create your account and let your mood guide your taste!',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 38,),

            Container(
              width: 280,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/male.png', width: 30, height: 200, fit: BoxFit.cover,),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none
                ),
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: 280,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Gender",
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/gender.png', width: 30, height: 200, fit: BoxFit.cover,),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: 280,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/letter.png', width: 30, height: 200, fit: BoxFit.cover,),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: 280,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/pass.png', width: 30, height: 180, fit: BoxFit.cover,),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/eye.png', width: 30, height: 200, fit: BoxFit.cover,),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: 280,
              height: 39,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1)
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Confirm Password",
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/pass.png', width: 30, height: 180, fit: BoxFit.cover,),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0),
                      child: Image.asset('assets/images/eye.png', width: 30, height: 200, fit: BoxFit.cover,),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),

            Stack(
              children: [
                Image.asset('assets/images/botlog.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have account ? ', style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  )
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                                      },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17,
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                        ),
                                      )
                                  )
                                ]
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Container(
                                width: 200,
                                height: 54,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: ElevatedButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavbar(currentIndex: 0,)));
                                },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFFFFBF69),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50), // Border radius tombol
                                      ),
                                    ),
                                    child: const Text('Sign In',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                            )

                          ],
                        )
                    )

                ),
              ],
            )

          ],
      ),
    );
  }
}