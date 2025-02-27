import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/lembur_controller.dart';

class LemburView extends GetView<LemburController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparan agar header bergelombang terlihat
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Form Lembur', style: TextStyle(color: Colors.white)),
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
              // Card untuk form lembur (digeser ke atas agar overlap dengan header)
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
                              'Lembur',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Pilih Tanggal Lembur
                          Obx(
                            () => ListTile(
                              leading: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Tanggal Lembur',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${controller.selectedDate.value.toLocal()}'
                                    .split(' ')[0],
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Icon(Icons.edit, color: Colors.white),
                              onTap: () => controller.selectDate(context),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Pilih Jam Mulai Lembur
                          Obx(
                            () => ListTile(
                              leading: Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Jam Mulai',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                controller.selectedTime.value.format(context),
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Icon(Icons.edit, color: Colors.white),
                              onTap: () => controller.selectTime(context),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Tombol Start/Stop Lembur
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF8B003),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => controller.toggleOvertime(),
                                child: Text(
                                  controller.isRunning.value
                                      ? 'Selesai Lembur'
                                      : 'Mulai Lembur',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
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
              // History Lembur
              Transform.translate(
                offset: Offset(0, -180),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'History Lembur',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Daftar History
              Transform.translate(
                offset: Offset(0, -250),
                child: Obx(
                  () => ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.history.length,
                    itemBuilder: (context, index) {
                      final session = controller.history[index];
                      return Card(
                        color: Colors.grey[800],
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(Icons.history, color: Colors.white),
                          title: Text(
                            'Mulai: ${session.start.toLocal()}'.split('.')[0],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            session.stop != null
                                ? 'Selesai: ${session.stop!.toLocal()}'.split(
                                  '.',
                                )[0]
                                : 'Sedang Berlangsung',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Clipper untuk membuat efek gelombang di header
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
