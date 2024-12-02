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
                      showModalFirst(context);
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

void showModalFirst(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Indicator
                Center(
                  child: Container(
                    width: 120,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 5, 5, 5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Average Rating
                Row(
                  children: [
                    const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 40,
                          color: Colors.amber,
                        ),
                        Icon(
                          Icons.star_outline,
                          size: 40,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: '4.5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          TextSpan(
                            text: '/5',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // List of Reviews (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        10, // jumlah ulasan
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Picture
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Bentuk bulat
                                  border: Border.all(
                                    color: Colors.black, // Warna border
                                    width: 1, // Ketebalan border
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),
                              // Review Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amelia Panjaitan ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (starIndex) => Padding(
                                          padding: const EdgeInsets.only(right: 4.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 25,
                                                color: starIndex < 4
                                                    ? Colors.amber
                                                    : Colors.grey[300], 
                                              ),
                                              const Icon(
                                                Icons.star_outline,
                                                size: 25,
                                                color: Colors.black, 
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Aku coba buatin nenek aku, katanya enak banget. Masakannya enak, namun sepertinya lebih baik jika takaran garamnya dibanyakin.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    
                                    // Rating Stars with Outline
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Input Field
                TextField(
                  onTap: () {
                    Navigator.pop(context); // Tutup modal pertama
                    showModalSecond(context); // Buka modal kedua
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Left a review',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



void showModalSecond(BuildContext context) { 
  int selectedRating = 0; // Menyimpan rating yang dipilih

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Agar modal bisa mengatur tinggi secara manual
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (BuildContext context) {
      // Menghitung tinggi 65% dari layar
      double height = MediaQuery.of(context).size.height * 0.55;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: height, // Mengatur tinggi modal menjadi 65% dari layar
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Drag Indicator
                    Container(
                      width: 120,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 5, 5, 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title Section
                    const Text(
                      'How Would You Rate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ayam Bawang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Rating Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1; // Update rating
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Lapisan Outline (Selalu hitam)
                              const Icon(
                                Icons.star_border,
                                color: Colors.black,
                                size: 40,
                              ),
                              if (index < selectedRating)
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 26, 
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Comment Section
                    TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Leave a review',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black, 
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black, 
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit action
                          Navigator.pop(context); // Close modal
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFBF69), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: Colors.black, 
                              width: 1.0, 
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8), 
                          minimumSize: Size(double.infinity, 30), 
                        ),
                        child: const Text(
                          'SEND',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
