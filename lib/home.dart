import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // 1. Sesuai nama akun
  final String accountName = "Goggins";

  // 2. State untuk Filter & Navbar
  int selectedFilterIndex = 0;
  int selectedNavIndex = 1; // Default di tengah (pie_chart)

  List<Map<String, String>> projects = [
    {"title": "Kopi", "subtitle": "Arduino Project"},
  ];

  void _addNewProject() {
    setState(() {
      projects.add({
        "title": "Project ${projects.length + 1}",
        "subtitle": "New Concept",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, $accountName 👋",
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const Text("Explore the App",
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Filter Buttons (Horizontal & Clickable)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 25),
                  children: [
                    _buildFilterItem("Most Viewed", 0),
                    _buildFilterItem("Latest", 1),
                    _buildFilterItem("Jarang", 2),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search places",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Project List (HORIZONTAL SCROLLING)
              SizedBox(
                height: 380,
                child: ListView.builder(
                  shrinkWrap: true,               // <-- PERUBAHAN HANYA DI SINI
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: projects.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAddProjectCard();
                    } else {
                      var project = projects[index - 1];
                      return _buildProjectCard(project['title']!, project['subtitle']!);
                    }
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Bottom Navbar (Interaktif)
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          border: Border(top: BorderSide(color: Color(0xFF222222))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.article_outlined, 0),
            _buildNavItem(Icons.pie_chart_outline_rounded, 1),
            _buildNavItem(Icons.person_outline_rounded, 2),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildFilterItem(String label, int index) {
    bool isSelected = selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedFilterIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF222222),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = selectedNavIndex == index;
    return IconButton(
      onPressed: () => setState(() => selectedNavIndex = index),
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey,
        size: 28,
      ),
    );
  }

  Widget _buildAddProjectCard() {
    return GestureDetector(
      onTap: _addNewProject,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create New Project", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Icon(Icons.add, size: 70),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1553406830-ef2513450d76?q=80&w=400"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}