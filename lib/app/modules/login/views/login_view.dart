import 'package:absen_raw/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang gelap
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.grey[900],
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.grey[900],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo atau Ilustrasi (circle container)
                // Agar kontras, kita gunakan warna abu-abu gelap dengan ikon kuning
                Image.asset(
                  'assets/logo/logo_autobenz2.png',
                  fit: BoxFit.cover,
                  width: 180,
                ),
                const SizedBox(height: 24),

                // Text "Welcome to LemonPie!"
                Text(
                  "Welcome Real Auto Workshop",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // warna teks terang
                  ),
                ),
                const SizedBox(height: 8),

                // Text "Keep your data safe"
                Text(
                  "Jaga keamanan data Anda",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400], // teks abu-abu
                  ),
                ),
                const SizedBox(height: 32),

                // TextField Email
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.white,
                  ), // teks input jadi putih
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[850], // background TextField gelap
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    hintText: "example@gmail.com",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.email, color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    // Outline saat aktif
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Obx digunakan untuk memantau perubahan isPasswordHidden
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[850],
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.yellow),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Warna kuning supaya kontras dengan latar belakang
                      backgroundColor: Colors.yellow[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => controller.login(),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Teks "Forgot password?"
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HOME);
                    // Arahkan ke halaman lupa password, misal: Get.toNamed('/forgot-password')
                  },
                  child: Text(
                    "Lupa kata sandi?",
                    style: TextStyle(
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                // Teks "Don't have an account? Register!"
                // Jika ingin menambahkan kembali link Register:
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Don’t have an account?",
                //       style: TextStyle(color: Colors.grey[400]),
                //     ),
                //     const SizedBox(width: 4),
                //     GestureDetector(
                //       onTap: () {
                //         // Arahkan ke halaman register, misal: Get.toNamed('/register')
                //       },
                //       child: Text(
                //         "Register!",
                //         style: TextStyle(
                //           color: Colors.yellow[700],
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
