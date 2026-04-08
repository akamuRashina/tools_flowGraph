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
        scaffoldBackgroundColor: const Color(0xFF121212), // Warna background gelap
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
  // Variabel Nama Akun
  final String accountName = "Goggins";

  // Data awal project
  List<Map<String, String>> projects = [
    {"title": "Kopi", "subtitle": "Arduino Project"},
  ];

  // Fungsi untuk menambah project baru
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
                    Text(
                      "Hi, $accountName 👋",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      "Explore the App",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // Filter Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: const [
                    FilterChip(label: "Most Viewed", isSelected: true),
                    FilterChip(label: "Latest"),
                    FilterChip(label: "Jarang"),
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
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.all(22),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF333333), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // Horizontal Project List
              SizedBox(
                height: 420,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: projects.length + 1, // +1 untuk tombol tambah
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Tombol Tambah (Create New Project)
                      return GestureDetector(
                        onTap: _addNewProject,
                        child: Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                            ),
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(color: const Color(0xFF333333)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Create New Project",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 30),
                              Icon(Icons.add_rounded, size: 100, weight: 100),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Item Project
                      var project = projects[index - 1];
                      return ProjectCard(
                        title: project['title']!,
                        subtitle: project['subtitle']!,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Bottom Navbar
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          border: Border(top: BorderSide(color: Color(0xFF222222), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.description_outlined, color: Colors.grey, size: 32),
            Icon(Icons.pie_chart_outline_rounded, color: Colors.grey, size: 32),
            Icon(Icons.person_outline_rounded, color: Colors.grey, size: 32),
          ],
        ),
      ),
    );
  }
}

// Widget untuk Chip Filter
class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const FilterChip({super.key, required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

// Widget untuk Card Project
class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const ProjectCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=400"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}