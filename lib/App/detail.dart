import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/home_screen.dart';
import 'package:jualan/App/navbar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final PageController _controller = PageController();
  final List<String> imagePaths = [
    'assets/images/gambardetail.png',
    'assets/images/imgayam.png',
    'assets/images/karbo.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 26, right: 26, top: 41),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavbar(currentIndex: 0,)));
                    },
                  icon: Image.asset('assets/images/close.png', width: 22.85, height: 22.85,),
                ),
                const SizedBox(width: 67,),
                const Text('Detail', style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                ),)
              ],
            ),
            const SizedBox(height: 16,),
            SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: imagePaths.length,
                  itemBuilder: (_, index) =>
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 200,
                        child: Image.asset(imagePaths[index], fit: BoxFit.cover,),
                      )
                )

            ),
            const SizedBox(height: 15,),
            Container(
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                  controller: _controller,
                  count: imagePaths.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.black
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black, // Warna border
                        width: 1, // Lebar border
                      ),
                    ),
                    width: 144,
                    height: 28,
                    child: ElevatedButton(onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.black),
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                                  ),
                                  padding: const EdgeInsets.only(top: 9.86, right: 14, left: 14),
                                  width: MediaQuery.of(context).size.width,
                                  height: 485,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 25.0,),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1),
                                                color: const Color(0XFFD9D9D9),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            width: (79.2 / MediaQuery.of(context).size.width) * MediaQuery.of(context).size.width,
                                            height: 8.55,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Image.asset('assets/images/closeprof.png'),
                                          )

                                        ],
                                      ),
                                      const SizedBox(height: 17.59,),
                                      const Center(
                                          child: Text('Ayam Bawang Betawi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),)
                                      ),
                                      const SizedBox(height: 20.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1, color: Colors.black),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            width: 100,
                                            height: 100,
                                            child: Image.asset('assets/images/ayamprof.png'),
                                          ),
                                          const SizedBox(width: 9,),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1, color: Colors.black),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            width: 100,
                                            height: 100,
                                            child: Image.asset('assets/images/ayamprof.png'),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 39),
                                        child: const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 15,),
                                            Text('Bahan - Bahan'),
                                            SizedBox(height: 8),
                                            Text("• 1 ekor ayam kampung muda/ayam pejantan (potong kecil2)"),
                                            Text("• 6 siung bawang putih (haluskan)"),
                                            Text("• 1 ruas jahe (haluskan)"),
                                            Text("• 2 bonggol bawang putih (geprek, jangan dikupas kulitnya)"),
                                            Text("• 1 sdt kecap asin"),
                                            Text("• 1 sdt saus tiram"),
                                            Text("• Secukupnya garam"),
                                          ],
                                        ),
                                      ),

                                    ],
                                  )
                              ),
                            );
                          }
                      );
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Border radius tombol
                            ),
                            padding: const EdgeInsets.only(left: 9, right: 8)
                        ),
                        child: const Text('Rate & Review',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )
                            ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black, // Warna border
                        width: 1, // Lebar border
                      ),
                    ),
                    width: 133,
                    height: 28,
                    child: ElevatedButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Detail()));
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Border radius tombol
                            ),
                            padding: const EdgeInsets.only(left: 9, right: 8)
                        ),
                        child: const Text('Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )
                        )
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ayam Bawang', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('assets/images/jam.png', fit: BoxFit.cover,)
                      ),
                      const SizedBox(width: 7,),
                      const Text('15 min', style: TextStyle(
                          fontSize: 16
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9,),
                  Row(
                    children: [
                      SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('assets/images/harvest.png', fit: BoxFit.cover,)
                      ),
                      const SizedBox(width: 7,),
                      const Text('5 ingredient(s)', style: TextStyle(
                          fontSize: 16
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9,),
                  Row(
                    children: [
                      SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('assets/images/serving.png', fit: BoxFit.cover,)
                      ),
                      const SizedBox(width: 7,),
                      const Text('1 serve(s)', style: TextStyle(
                          fontSize: 16
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9,),
                  Row(
                    children: [
                      SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset('assets/images/fav.png', fit: BoxFit.cover,)
                      ),
                      const SizedBox(width: 7,),
                      const Text('4,3', style: TextStyle(
                          fontSize: 16
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices, est in lobortis aliquam, sem urna venenatis nulla, eget sodales tellus enim vitae ipsum. Cras volutpat vestibulum mattis. Nullam id elit dapibus, pellentesque dolor nec, accumsan sapien. In est enim bibendum id semper sit amet convallis sit amet ligula Maecenas blandit blandit mi. Nam maximus neque risus')
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
