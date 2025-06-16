import 'package:flutter/material.dart';

import '../fragment/fragment_generate_image.dart';
import '../fragment/fragment_generate_text.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text('Terjemahan Gemini AI',
            style: TextStyle(
                color: Colors.white
            )
        ),
        bottom: setTabBar(),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          FragmentGenerateText(),
          FragmentGenerateImage(),
        ],
      ),
    );
  }

  TabBar setTabBar() {
    return TabBar(
        controller: tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black26,
        indicatorColor: Colors.white,
        tabs: const [
          Tab(
            text: 'Terjemahkan Teks',
            icon: Icon(Icons.text_fields),
          ),
          Tab(
            text: 'Terjemahkan Gambar',
            icon: Icon(Icons.image_search),
          ),
        ]
    );
  }
}