import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model sederhana untuk sesi lembur
class OvertimeSession {
  DateTime start;
  DateTime? stop;
  OvertimeSession({required this.start, this.stop});
}

class LemburController extends GetxController {
  // Tanggal lembur (default hari ini)
  var selectedDate = DateTime.now().obs;
  // Jam lembur (default sekarang)
  var selectedTime = TimeOfDay.now().obs;
  // Status lembur (sedang berjalan atau tidak)
  var isRunning = false.obs;
  // Sesi lembur saat ini (jika sedang berjalan)
  Rx<OvertimeSession?> currentSession = Rx<OvertimeSession?>(null);
  // History sesi lembur
  var history = <OvertimeSession>[].obs;

  // Pilih tanggal lembur menggunakan showDatePicker dengan tema dark
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
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Pilih jam lembur menggunakan showTimePicker dengan tema dark
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: TimePickerThemeData(
              dialBackgroundColor: Colors.grey[800],
              hourMinuteTextColor: Colors.white,
              dialHandColor: Color(0xFFF8B003),
            ),
          ),
          child: child ?? SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  // Menggabungkan tanggal dan waktu menjadi DateTime
  DateTime get startDateTime {
    return DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );
  }

  // Mulai lembur: buat sesi baru dan tandai sebagai running
  void startOvertime() {
    if (!isRunning.value) {
      currentSession.value = OvertimeSession(start: startDateTime);
      isRunning.value = true;
    }
  }

  // Selesaikan lembur: set waktu selesai dan simpan ke history
  void stopOvertime() {
    if (isRunning.value && currentSession.value != null) {
      currentSession.value!.stop = DateTime.now();
      history.add(currentSession.value!);
      currentSession.value = null;
      isRunning.value = false;
    }
  }

  // Toggle lembur: jika sedang berjalan, stop; jika tidak, mulai
  void toggleOvertime() {
    if (isRunning.value) {
      stopOvertime();
    } else {
      startOvertime();
    }
  }
}
