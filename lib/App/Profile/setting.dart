import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget{
  const Setting({super.key});
  @override
  State<Setting> createState() => _Setting();
}

class _Setting extends State<Setting>{
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: const Color(0xFFFDF7F1),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 47),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 62,
                ),
                const Text('Profile', style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                ),),
                IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
                    },
                    icon: Image.asset('assets/images/setting.png')
                )
              ],
            ),
            const SizedBox(height: 37,),
            const Text('Account Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 23,),
            SizedBox(
              height: 26,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDF7F1),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(MediaQuery.of(context).size.width, 26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide.none,
                  ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                ),
                onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/set_customer.png'),
                        const SizedBox(width: 11,),
                        const Text('Personal Information', style: TextStyle(fontSize: 13, color: Colors.black),),
                      ],
                    ),
                    Image.asset('assets/images/next.png'),
                  ]
                ),
              )
            ),
            const SizedBox(height: 12),
            SizedBox(
                height: 26,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDF7F1),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(MediaQuery.of(context).size.width, 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide.none,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: (){},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/pass.png', height: 26, width: 25,),
                            const SizedBox(width: 11,),
                            const Text('Password and Security', style: TextStyle(fontSize: 13, color: Colors.black),),
                          ],
                        ),
                        Image.asset('assets/images/next.png'),
                      ]
                  ),
                )
            ),
            const SizedBox(height: 12),
            SizedBox(
                height: 26,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDF7F1),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(MediaQuery.of(context).size.width, 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide.none,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: (){},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/notif.png', height: 26, width: 26,),
                            const SizedBox(width: 11,),
                            const Text('Notification Preferences', style: TextStyle(fontSize: 13, color: Colors.black),),
                          ],
                        ),
                        Image.asset('assets/images/next.png'),
                      ]
                  ),
                )
            ),
            const SizedBox(height: 12),
            SizedBox(
                height: 26,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDF7F1),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(MediaQuery.of(context).size.width, 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide.none,
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: (){},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/language.png'),
                            const SizedBox(width: 11,),
                            const Text('Notification Preferences', style: TextStyle(fontSize: 13, color: Colors.black),),
                          ],
                        ),
                        Image.asset('assets/images/next.png'),
                      ]
                  ),
                )
            ),
            const SizedBox(height: 55),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  backgroundColor: WidgetStateProperty.all(const Color(0XFFFFBF69)),
                  minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, 34)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}