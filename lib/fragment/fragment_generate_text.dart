import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/global_variable.dart';

class FragmentGenerateText extends StatefulWidget {
  const FragmentGenerateText({super.key});

  @override
  State<FragmentGenerateText> createState() => _FragmentGenerateTextState();
}

class _FragmentGenerateTextState extends State<FragmentGenerateText> {
  TextEditingController textEditingController = TextEditingController();
  String strAnswer = '';
  bool visibleSP = false;
  String selectedLanguage = 'Bahasa Indonesia';
  var listLanguage = ['Bahasa Indonesia', 'Bahasa Inggris', 'Bahasa China',
    'Bahasa Arab', 'Bahasa Jepang', 'Bahasa Korea', 'Bahasa Prancis',
    'Bahasa Jerman', 'Bahasa Jawa', 'Bahasa Sunda'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: textEditingController,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.red,
                          icon: Icon(textEditingController.text.isNotEmpty
                              ? Icons.cancel
                              : null),
                          onPressed: () {
                            textEditingController.clear();
                            visibleSP = false;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(
                          color: Colors.lightBlue,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Masukkan teks...',
                    labelStyle: const TextStyle(
                        color: Colors.black)
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
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text('Ups, keyword tidak boleh kosong!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Chirp')
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      shape: StadiumBorder(),
                      behavior: SnackBarBehavior.floating,
                    ));
                  } else {
                    visibleSP = true;
                    GenerativeModel model = GenerativeModel(
                        model: 'gemini-1.5-flash-latest',
                        apiKey: API_KEY);
                    model.generateContent([
                      Content.text('Ubah ke $selectedLanguage dan hanya tampilkan jawaban tanpa penjelasan dari kalimat:${textEditingController.text}'),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: MarkdownBody(
                        data: strAnswer
                    ),
                  ),
                )
            )
          ],
        )
    );
  }
}