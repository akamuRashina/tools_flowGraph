import 'package:flutter/material.dart';

void main() {
  runApp(const FlowWireApp());
}

class FlowWireApp extends StatelessWidget {
  const FlowWireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlowWire Create Account',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF151515),
        fontFamily:
            'Poppins', // Pastikan Anda menambahkan font Poppins di pubspec.yaml untuk hasil 100% akurat
      ),
      home: const CreateAccountPage(),
    );
  }
}

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // --- Bagian Logo & Nama Brand ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(width: 12),
                    const Text(
                      'FlowWire',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- Judul Halaman ---
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // --- Form Input ---
                _buildTextField(hint: 'Email address...'),
                const SizedBox(height: 20),
                _buildTextField(hint: 'Password...', isPassword: true),
                const SizedBox(height: 20),
                _buildTextField(hint: 'Username...'),
                const SizedBox(height: 40),

                // --- Garis Pembatas 'Or' ---
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Tombol Sign up Google ---
                _buildGoogleButton(),
                const SizedBox(height: 30),

                // --- Tombol Submit Create Account ---
                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                    onPressed: () {
                      // Fungsi register
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget custom untuk logo tumpuk Elips (Putih & Oranye)
  Widget _buildLogo() {
    return SizedBox(
      width: 32.98,
      height: 40.85,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 20.28,
              height: 34.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: 12.61, // Perkiraan jarak antar elips berdasarkan left CSS
            top: 5.12, // Perkiraan jarak vertikal
            child: Container(
              width: 20.36,
              height: 35.73,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9100),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget custom untuk kolom Input Teks
  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return Container(
      height: 53,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.05,
        ), // Visualisasi dark semi-transparent
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Widget custom untuk tombol Google
  Widget _buildGoogleButton() {
    return Container(
      width: double.infinity,
      height: 53,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.11),
        borderRadius: BorderRadius.circular(
          127,
        ), // Rounded bentuk pil sesuai desain
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(127),
          onTap: () {
            // Fungsi login Google
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan icon bawaan sebagai pengganti SVG logo Google
              Container(
                width: 29,
                height: 29,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Google',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
