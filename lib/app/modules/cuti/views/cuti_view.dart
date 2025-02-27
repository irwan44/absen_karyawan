import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cuti_controller.dart';

class CutiView extends GetView<CutiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparan agar header bergelombang terlihat
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Form Cuti', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              // Header bergelombang
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
              // Gunakan Transform.translate untuk menggeser card ke atas agar tumpang tindih dengan header
              Transform.translate(
                offset: Offset(0, -190),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: Colors.grey[850],
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Ajukan Cuti',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Date Picker "Dari Tanggal"
                          Obx(
                            () => ListTile(
                              leading: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Dari Tanggal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${controller.startDate.value.toLocal()}'.split(
                                  ' ',
                                )[0],
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Icon(Icons.edit, color: Colors.white),
                              onTap: () => controller.selectStartDate(context),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Date Picker "Sampai Tanggal"
                          Obx(
                            () => ListTile(
                              leading: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Sampai Tanggal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${controller.endDate.value.toLocal()}'.split(
                                  ' ',
                                )[0],
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Icon(Icons.edit, color: Colors.white),
                              onTap: () => controller.selectEndDate(context),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Field untuk memasukkan alasan cuti
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Alasan Cuti',
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Masukkan alasan cuti...',
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
                            onChanged:
                                (value) => controller.reason.value = value,
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
                              onPressed: () => controller.submit(),
                              child: Text(
                                'Ajukan Cuti',
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
              // Tambahan jarak bawah (opsional)
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Clipper untuk efek gelombang di header
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
