import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/endpoint.dart'; // import API login Anda

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validasi sederhana
    if (email.isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Format email tidak valid");
      return;
    }
    if (password.isEmpty) {
      Get.snackbar("Error", "Password tidak boleh kosong");
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Error", "Password minimal 6 karakter");
      return;
    }

    try {
      // Panggil API login
      await API.login(email: email, password: password);

      // Jika berhasil, class API sudah otomatis menampilkan snackbar
      // dan melakukan Get.offAllNamed(Routes.HOME) di dalamnya.
      // Anda tidak perlu lagi menambahkan logika navigasi di sini.
    } catch (e) {
      // Tangani error lain, misal jaringan putus, dll
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
