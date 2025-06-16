import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/global_variable.dart';

class FragmentGenerateImage extends StatefulWidget {
  const FragmentGenerateImage({super.key});

  @override
  State<FragmentGenerateImage> createState() => _FragmentGenerateImageState();
}

class _FragmentGenerateImageState extends State<FragmentGenerateImage> {
  String strAnswer = '';
  bool visibleSP = false;
  File? imageFile;
  final imagePicker = ImagePicker();
  String selectedLanguage = 'Bahasa Indonesia';
  var listLanguage = ['Bahasa Indonesia', 'Bahasa Inggris', 'Bahasa China',
    'Bahasa Arab', 'Bahasa Jepang', 'Bahasa Korea', 'Bahasa Prancis',
    'Bahasa Jerman', 'Bahasa Jawa', 'Bahasa Sunda'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 40, left: 20, right: 20
                          ),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)
                                  )
                              ),
                              height: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              getFromGallery();
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(200)
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.center,
                                                    colors: [
                                                      Colors.red,
                                                      Colors.redAccent
                                                    ],
                                                  )
                                              ),
                                              child: const Icon(
                                                Icons.image_search_outlined,
                                                color: Colors.white,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Galeri',
                                        ),
                                      ]
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            getFromCamera();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(200)
                                                ),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.center,
                                                  colors: [
                                                    Colors.blue,
                                                    Colors.blueAccent
                                                  ],
                                                )
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Kamera',
                                      ),
                                    ],
                                  )
                                ],
                              )
                          )
                      );
                    });
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                width: size.width,
                height: 250,
                child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    color: Colors.lightBlue,
                    strokeWidth: 1,
                    dashPattern: const [5, 5],
                    child: SizedBox.expand(
                        child: FittedBox(
                            child: imageFile != null
                                ? Image.file(File(imageFile!.path), fit: BoxFit.cover)
                                : const Icon(Icons.image_search, color: Colors.lightBlue,
                            )
                        )
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: Colors.lightBlue,
                      style: BorderStyle.solid,
                      width: 1
                  ),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  hint: const Text('Select Language:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )
                  ),
                  value: selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value.toString();
                    });
                  },
                  items: listLanguage.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  isExpanded: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: const StadiumBorder()
                ),
                onPressed: () {
                  if (imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(
                                  'Ups, keyword dan gambar tidak boleh kosong!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Chirp')
                              )
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      shape: StadiumBorder(),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                  else {
                    visibleSP = true;
                    GenerativeModel model = GenerativeModel(
                        model: 'gemini-1.5-flash-latest', apiKey: API_KEY);
                    model.generateContent([
                      Content.multi([
                        TextPart('Ubah ke $selectedLanguage dan hanya tampilkan jawaban tanpa penjelasan dari teks digambar tersebut'),
                        if (imageFile != null)
                          DataPart('image/jpeg',
                              File(imageFile!.path).readAsBytesSync()
                          )
                      ]),
                    ]).then((value) => setState(() {
                      strAnswer = value.text.toString();
                    }));
                  }
                },
                child: const Text('Terjemahkan'),
              ),
            ),
            Visibility(
                visible: visibleSP,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue,),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: MarkdownBody(data: strAnswer),
                  ),
                )
            )
          ],
        )
    );
  }

  // get from gallery
  getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // get from camera
  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}