import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/izin_controller.dart';

class IzinView extends GetView<IzinController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // Buat app bar transparan agar gelombang header terlihat
      appBar: AppBar(
        title: Text(
          'Form Izin',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.grey[900],
        child: Stack(
          children: [
            // Header bergelombang dengan ClipPath
            ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8B003), Color(0xFFF8B003)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Konten form di dalam Card, dengan dark mode style
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10, 20, 16, 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.grey[850]!, Colors.grey[800]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Form Ajukan Izin',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Pilihan tanggal
                        Obx(
                          () => ListTile(
                            leading: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 15,
                            ),
                            title: Text(
                              'Tanggal Izin',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            subtitle: Text(
                              '${controller.selectedDate.value.toLocal()}'
                                  .split(' ')[0],
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                            onTap: () => controller.selectDate(context),
                          ),
                        ),
                        SizedBox(height: 15),
                        // Dropdown untuk memilih tipe izin
                        Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Tipe Izin',
                              labelStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            dropdownColor: Colors.grey[850],
                            value: controller.selectedType.value,
                            items:
                                <String>[
                                  'Sakit',
                                  'Keperluan Pribadi',
                                  'Lainnya',
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null)
                                controller.selectedType.value = value;
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        // Field untuk memasukkan alasan izin
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Alasan',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Masukkan alasan izin...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          maxLines: 3,
                          onChanged: (value) => controller.reason.value = value,
                        ),
                        SizedBox(height: 20),
                        // Tombol submit
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF8B003),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              controller.submit();
                            },
                            child: Text(
                              'Ajukan Izin',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper untuk membuat efek gelombang di bagian atas
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Mulai dari kiri atas
    path.lineTo(0, size.height - 50);
    // Kurva pertama
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    // Kurva kedua
    var secondControlPoint = Offset(3 * size.width / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
