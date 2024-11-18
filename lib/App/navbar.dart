import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/Profile/profile.dart';
import 'package:jualan/App/Toss/main.dart';
import 'package:jualan/App/detail.dart';
import 'package:jualan/App/favourites.dart';
import 'package:jualan/App/home_screen.dart';
import 'package:jualan/App/saved.dart';
import 'package:jualan/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavbar(),
    );
  }
}


class BottomNavbar extends StatefulWidget{
  final int currentIndex;
  const BottomNavbar({super.key, this.currentIndex = 0});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}
class _BottomNavbarState extends State<BottomNavbar>{
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    // Set currentIndex to the passed value or default to 0
    currentIndex = widget.currentIndex;
  }
  List screens = const[
    HomeScreen(),
    FavouritesScreen(),
    SavedScreen(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TossTaste()));
        },
          shape: const CircleBorder(),
          backgroundColor: circle,
          child: Image.asset('assets/images/floaticon.png',),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        child: BottomAppBar(
          height: 80,
          color: Colors.white,
          elevation: 1,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Image.asset(
                  'assets/images/home.png',
                ),
                iconSize: 37.0,
                color: currentIndex == 0 ? iactive : inoactive,
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Image.asset('assets/images/love.png'),
                iconSize: 37.0,
                color: currentIndex == 1 ? iactive : inoactive,
              ),
              const SizedBox(width: 34,),
              IconButton(
                onPressed: (){
                  setState(() {
                    currentIndex = 2;
                  });
                },
                icon: Image.asset('assets/images/save.png'),
                iconSize: 37.0,
                color: currentIndex == 3 ? iactive : inoactive,
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    currentIndex = 3;
                  });
                },
                icon: Image.asset('assets/images/profile.png'),
                iconSize: 37.0,
                color: currentIndex == 4 ? iactive : inoactive,
              )
            ],
          ),
        ),
      ),
        body: screens[currentIndex]

    );
  }
}