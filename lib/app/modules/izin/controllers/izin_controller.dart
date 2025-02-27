import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IzinController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var selectedType = 'Sakit'.obs;
  var reason = ''.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  // Fungsi untuk memilih tanggal izin
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(primary: Color(0xFFF8B003)),
          ),
          child: child ?? SizedBox.shrink(),
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  // Fungsi submit untuk validasi dan mengirim data izin
  void submit() {
    // Validasi atau logika pengiriman data bisa ditambahkan di sini
    Get.snackbar(
      'Info',
      'Izin berhasil diajukan!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
