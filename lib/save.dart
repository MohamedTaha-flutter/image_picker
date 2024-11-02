import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path; // استيراد مكتبة path
import 'package:gallery_saver/gallery_saver.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: _image == null ? null : FileImage(_image!),
                radius: 80,
              ),
              IconButton(
                onPressed: showImageSourceDialog,
                icon: Icon(Icons.camera_alt_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('اختر مصدر الصورة'),
          actions: [
            TextButton(
              child: Text('الكاميرا'),
              onPressed: () {
                Navigator.of(context).pop();
                imagePicker(ImageSource.camera);
              },
            ),
            TextButton(
              child: Text('المعرض'),
              onPressed: () {
                Navigator.of(context).pop();
                imagePicker(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void imagePicker(ImageSource source) async {
    final imagePic = await ImagePicker().pickImage(source: source);
    if (imagePic != null) {
      setState(() {
        _image = File(imagePic.path);
      });
      // حفظ الصورة في المعرض
      saveImageToGallery(imagePic);
    }
  }

  Future<void> saveImageToGallery(XFile imagePic) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = path.join(directory.path, imagePic.name);

    // نقل الصورة إلى المسار الجديد
    await File(imagePic.path).copy(imagePath);

    // حفظ الصورة في المعرض
    final result = await GallerySaver.saveImage(imagePath);
    if (result != null && result) {
      print('الصورة تم حفظها في المعرض بنجاح!');
    } else {
      print('فشل في حفظ الصورة في المعرض.');
    }
  }
}
