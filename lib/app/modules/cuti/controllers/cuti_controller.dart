import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CutiController extends GetxController {
  // State untuk tanggal mulai cuti, defaultnya adalah hari ini
  Rx<DateTime> startDate = DateTime.now().obs;
  // State untuk tanggal akhir cuti, defaultnya adalah besok
  Rx<DateTime> endDate = DateTime.now().add(Duration(days: 1)).obs;
  // State untuk alasan cuti
  RxString reason = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fungsi untuk memilih tanggal mulai cuti
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value,
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
    if (picked != null && picked != startDate.value) {
      startDate.value = picked;
      // Jika tanggal akhir kurang dari tanggal mulai, update tanggal akhir
      if (endDate.value.isBefore(picked)) {
        endDate.value = picked.add(Duration(days: 1));
      }
    }
  }

  // Fungsi untuk memilih tanggal akhir cuti
  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value,
      firstDate: startDate.value,
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
    if (picked != null && picked != endDate.value) {
      endDate.value = picked;
    }
  }

  // Fungsi untuk submit pengajuan cuti
  void submit() {
    // Validasi sederhana: pastikan alasan tidak kosong
    if (reason.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Harap masukkan alasan cuti',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Tampilkan notifikasi sukses
    Get.snackbar(
      'Info',
      'Cuti berhasil diajukan dari ${startDate.value.toLocal().toString().split(' ')[0]} sampai ${endDate.value.toLocal().toString().split(' ')[0]}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFF8B003),
      colorText: Colors.black,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 2),
    );
  }
}
