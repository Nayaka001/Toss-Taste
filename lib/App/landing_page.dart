import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/login.dart';
import 'register.dart';
import 'login.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Landing(),
    );
  }
}

class Landing extends StatelessWidget{
  const Landing ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50),
            alignment: Alignment.center,
            child: const Text('Welcome to', style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),),
          ),
          const SizedBox(height: 39,),
          Container(
            margin: const EdgeInsets.only(bottom: 30.21),
            child: Image.asset('assets/images/topland.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0XFFCBF3F0),
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(30)
            ),
            width: 312,
            height: 250,
            padding: const EdgeInsets.only(left: 27.79, top: 28.5),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/resep.png'),
                    const SizedBox(width: 27.75,),
                    const Text('Beragam Resep', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 21.2,),
                SizedBox(
                  width: 272,
                  height: 1,
                  child: Container(
                    color: const Color(0x1A000000),
                  ),
                ),
                const SizedBox(height: 9.26,),
                Row(
                  children: [
                    Image.asset('assets/images/cari.png'),
                    const SizedBox(width: 27.75,),
                    const SizedBox(
                      width: 173,
                      child: Text('Mencari resep sesuai bahan yang kamu punya', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    )

                  ],
                ),
                const SizedBox(height: 22.57,),
                SizedBox(
                  width: 272,
                  height: 1,
                  child: Container(
                    color: const Color(0x1A000000),
                  ),
                ),
                const SizedBox(height: 9.26,),
                Row(
                  children: [
                    Image.asset('assets/images/unggah.png'),
                    const SizedBox(width: 27.75,),
                    const SizedBox(
                      width: 173,
                      child: Text('Mengunggah resep andalan kamu', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 17.64,),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(50)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 80),
            width: 200,
            height: 54,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFBF69),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)
                )
              ),
              child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(50)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 80),
            width: 200,
            height: 54,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  Login()));
            },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC4B6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)
                  )
              ),
              child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
            ),
          ),
        ],
      ),
    );
  }

}

