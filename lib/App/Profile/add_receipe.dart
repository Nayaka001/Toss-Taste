import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jualan/App/navbar.dart';

class AddReceipe extends StatefulWidget {
  const AddReceipe({super.key});
  @override
  State<AddReceipe> createState() => _AddReceipe();
}

class _AddReceipe extends State<AddReceipe> {
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String fileName = result.files.single.name;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File yang dipilih: $fileName')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada file yang dipilih')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F1),
      body: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 41),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavbar(currentIndex: 3),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/close.png',
                    width: 22.85,
                    height: 22.85,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: const Center(
                    child: Text(
                      'Add Recipe',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 33),
            const Text(
              'Enter the title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              height: 41,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              width: 53,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFCBF3F0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              child: Icon(Icons.add, size: 28, weight: 900),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add time estimation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              height: 41,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add serves amount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              height: 41,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              height: 290,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black), // Border luar
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: TextField(
                    controller: TextEditingController(),
                    maxLines: null,
                    expands: false,

                    decoration: const InputDecoration(
                      hintText: 'Enter a description',
                      hintStyle: TextStyle(color: Color.fromARGB(255, 104, 102, 102)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10.0, top: 9.0, right: 10.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: 126,
              height: 25,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFFCBF3F0)),
                  padding: WidgetStateProperty.all(EdgeInsets.zero), 
                ),
                onPressed: _pickFile,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/attach.png',
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'File Attach',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  backgroundColor: WidgetStateProperty.all(const Color(0XFFFFBF69)),
                  minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, 34)),
                ),
                onPressed: () {},
                child: const Text(
                  'POST',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}