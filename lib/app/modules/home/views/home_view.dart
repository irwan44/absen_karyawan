import 'package:absen_raw/app/modules/home/controllers/home_controller.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/localstorage.dart';
import '../../../routes/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late RefreshController _refreshController;
  void _handleAbsenMasuk() async {
    await controller.absenMasuk();
    _onRefresh();
  }

  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String getRoleName() {
    final posisi = LocalStorages.getPosisi;
    final mapping = {
      "1": "Administrator",
      "2": "Kepala Bengkel",
      "3": "Service Advisor",
      "4": "Mekanik",
      "5": "Forman",
      "6": "Staff",
      "7": "Part Head",
      "8": "Partman",
      "9": "Part Manager",
      "10": "Keuangan",
      "11": "Leader",
      "12": "Owner",
    };
    if (posisi == null) return "Role anda tidak terdeteksi";
    return mapping[posisi.toString()] ?? "Role anda tidak terdeteksi";
  }

  @override
  Widget build(BuildContext context) {
    controller.checkForUpdate();
    return FadeTransition(
      opacity: _fadeAnimation,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.grey[900],
            ),
            automaticallyImplyLeading: false,
            title: const Text('Absensi', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 0,
            actions: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Pengaturan Aplikasi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    AppSettings.openAppSettings(
                                      type: AppSettingsType.notification,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.settings,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Notifikasi',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.notifications_active_rounded,
                                          color: Colors.grey.shade400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    AppSettings.openAppSettings(
                                      type: AppSettingsType.location,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.settings,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'GPS',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.gps_fixed_rounded,
                                          color: Colors.grey.shade400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    AppSettings.openAppSettings(
                                      type: AppSettingsType.sound,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    margin: EdgeInsets.only(
                                      right: 10,
                                      left: 10,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.settings,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Suara',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.surround_sound_rounded,
                                          color: Colors.grey.shade400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        showDragHandle: true,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 16),
                                Text(
                                  'Anda akan keluar dari aplikasi. Apakah Anda yakin ingin logout?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 24),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Colors.red, // Warna teks/icon
                                    minimumSize: Size(
                                      double.infinity,
                                      50,
                                    ), // Lebar penuh, tinggi 50
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    LocalStorages.deleteToken();

                                    Get.offAllNamed(Routes.LOGIN);
                                  },
                                  icon: Icon(Icons.logout, color: Colors.white),
                                  label: Text(
                                    'Logout',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.logout_rounded, color: Colors.redAccent),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              // Wave background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
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
              ),
              SafeArea(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  header: const WaterDropHeader(),
                  onLoading: _onLoading,
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Profile
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.my_location, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text(
                              "Lokasi Anda",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => controller.getCurrentLocation(),
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white70,
                              ),
                              tooltip: 'Refresh lokasi',
                            ),
                          ],
                        ),
                        Obx(() {
                          return Text(
                            controller.address.value.isEmpty
                                ? "Memuat alamat..."
                                : controller.address.value,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          );
                        }),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            margin: const EdgeInsets.only(top: 24),
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
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Obx(
                                    () => Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.nama.value,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              _buildInfoRow(
                                                icon: Icons.phone,
                                                label:
                                                    controller
                                                        .nomorHandphone
                                                        .value,
                                              ),
                                              const SizedBox(height: 4),
                                              _buildInfoRow(
                                                icon: Icons.work_outline,
                                                label: getRoleName(),
                                              ),
                                              const SizedBox(height: 4),
                                              _buildInfoRow(
                                                icon: Icons.schedule,
                                                label:
                                                    "Jam Kerja: ${controller.jamKerja.value}",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                              'assets/logo/logo_autobenz2.png',
                                              fit: BoxFit.cover,
                                              width: 70,
                                            ),
                                            SizedBox(height: 50),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GetBuilder<HomeController>(
                                    builder: (controller) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(
                                            () => ElevatedButton.icon(
                                              icon:
                                                  controller
                                                          .isLoadingAbsenMasuk
                                                          .value
                                                      ? SizedBox(
                                                        width: 18,
                                                        height: 18,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      )
                                                      : Icon(
                                                        Icons.login,
                                                        size: 18,
                                                        color:
                                                            controller
                                                                    .isAbsenMasukDone
                                                                    .value
                                                                ? Colors.grey
                                                                : Colors.white,
                                                      ),
                                              label: Text(
                                                "Absen Masuk",
                                                style: TextStyle(
                                                  color:
                                                      controller
                                                              .isAbsenMasukDone
                                                              .value
                                                          ? Colors.grey
                                                          : Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    controller
                                                            .isAbsenMasukDone
                                                            .value
                                                        ? Colors.grey
                                                        : const Color(
                                                          0xFFF8B003,
                                                        ),
                                              ),
                                              onPressed:
                                                  controller
                                                              .isAbsenMasukDone
                                                              .value ||
                                                          controller
                                                              .isLoadingAbsenMasuk
                                                              .value
                                                      ? null
                                                      : () async {
                                                        await controller
                                                            .absenMasuk();
                                                        await controller
                                                            .refreshData();
                                                      },
                                            ),
                                          ),
                                          Obx(
                                            () => ElevatedButton.icon(
                                              icon:
                                                  controller
                                                          .isLoadingAbsenPulang
                                                          .value
                                                      ? SizedBox(
                                                        width: 18,
                                                        height: 18,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      )
                                                      : Icon(
                                                        Icons.logout,
                                                        size: 18,
                                                        color:
                                                            controller
                                                                    .isAbsenPulangDone
                                                                    .value
                                                                ? Colors.grey
                                                                : Colors.white,
                                                      ),
                                              label: Text(
                                                "Absen Pulang",
                                                style: TextStyle(
                                                  color:
                                                      controller
                                                              .isAbsenPulangDone
                                                              .value
                                                          ? Colors.grey
                                                          : Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    controller
                                                            .isAbsenPulangDone
                                                            .value
                                                        ? Colors.grey
                                                        : const Color(
                                                          0xFFF8B003,
                                                        ),
                                              ),
                                              onPressed:
                                                  controller
                                                              .isAbsenPulangDone
                                                              .value ||
                                                          controller
                                                              .isLoadingAbsenPulang
                                                              .value
                                                      ? null
                                                      : () async {
                                                        await controller
                                                            .absenPulang();
                                                        await controller
                                                            .refreshData();
                                                      },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Card Lokasi GPS & Alamat
                        // Tombol Absen Masuk dan Absen Pulang
                        const SizedBox(height: 20),
                        Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Menu Ijin
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.IZIN);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue[100],
                                        ),
                                        child: Icon(
                                          Icons.event_note,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Izin",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Menu Cuti
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.CUTI);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green[100],
                                        ),
                                        child: Icon(
                                          Icons.beach_access,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Cuti",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Menu Lembur
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.LEMBUR);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orange[100],
                                        ),
                                        child: Icon(
                                          Icons.timer,
                                          size: 30,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Lembur",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Riwayat Absen
                        Obx(() {
                          DateTime now = DateTime.now();

                          // Filter data absen untuk hari ini
                          final todayRecords =
                              controller.absenHistoryList.where((record) {
                                if (record.tglAbsen == null) return false;
                                try {
                                  DateTime recordDate =
                                      DateTime.parse(
                                        record.tglAbsen!,
                                      ).toLocal();
                                  return recordDate.year == now.year &&
                                      recordDate.month == now.month &&
                                      recordDate.day == now.day;
                                } catch (e) {
                                  return false;
                                }
                              }).toList();

                          // Filter data absen untuk hari-hari sebelumnya (riwayat)
                          final historyRecords =
                              controller.absenHistoryList.where((record) {
                                if (record.tglAbsen == null) return false;
                                try {
                                  DateTime recordDate =
                                      DateTime.parse(
                                        record.tglAbsen!,
                                      ).toLocal();
                                  return !(recordDate.year == now.year &&
                                      recordDate.month == now.month &&
                                      recordDate.day == now.day);
                                } catch (e) {
                                  return false;
                                }
                              }).toList();

                          // Default tab: jika ada data hari ini, maka pilih tab "Absen Sekarang" (index 0)
                          int initialTab = todayRecords.isNotEmpty ? 0 : 1;

                          return DefaultTabController(
                            length: 2,
                            initialIndex: initialTab,
                            child: Column(
                              children: [
                                TabBar(
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.white70,
                                  indicatorColor: Colors.white,
                                  tabs: const [
                                    Tab(text: "Absen Sekarang"),
                                    Tab(text: "Riwayat Absen"),
                                  ],
                                ),
                                // Container dengan tinggi tertentu agar layout tidak error
                                Container(
                                  height: 400,
                                  child: TabBarView(
                                    children: [
                                      // Tab "Absen Sekarang"
                                      todayRecords.isNotEmpty
                                          ? ListView.builder(
                                            itemCount: todayRecords.length,
                                            itemBuilder: (context, index) {
                                              final record =
                                                  todayRecords[index];
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.grey[800]!,
                                                      Colors.grey[700]!,
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  leading: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (record.jamKeluar ==
                                                                      null ||
                                                                  record
                                                                      .jamKeluar!
                                                                      .isEmpty)
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                    0.2,
                                                                  )
                                                              : Colors.red
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      (record.jamKeluar ==
                                                                  null ||
                                                              record
                                                                  .jamKeluar!
                                                                  .isEmpty)
                                                          ? Icons.login
                                                          : Icons.logout,
                                                      color:
                                                          (record.jamKeluar ==
                                                                      null ||
                                                                  record
                                                                      .jamKeluar!
                                                                      .isEmpty)
                                                              ? Colors.green
                                                              : Colors.red,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    record.tglAbsen ??
                                                        "Tanggal -",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "Masuk: ${record.jamMasuk ?? "-"} | Pulang: ${record.jamKeluar ?? "-"}\nKet: ${record.keterangan ?? "-"}",
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          : Center(
                                            // Jika tidak ada data absen hari ini, tampilkan form absen
                                            child: Text(
                                              "Belum ada absensi",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                      // Tab "Riwayat Absen"
                                      historyRecords.isNotEmpty
                                          ? ListView.builder(
                                            itemCount: historyRecords.length,
                                            itemBuilder: (context, index) {
                                              final record =
                                                  historyRecords[index];
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.grey[800]!,
                                                      Colors.grey[700]!,
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                      blurRadius: 5,
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  leading: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (record.jamKeluar ==
                                                                      null ||
                                                                  record
                                                                      .jamKeluar!
                                                                      .isEmpty)
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                    0.2,
                                                                  )
                                                              : Colors.red
                                                                  .withOpacity(
                                                                    0.2,
                                                                  ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      (record.jamKeluar ==
                                                                  null ||
                                                              record
                                                                  .jamKeluar!
                                                                  .isEmpty)
                                                          ? Icons.login
                                                          : Icons.logout,
                                                      color:
                                                          (record.jamKeluar ==
                                                                      null ||
                                                                  record
                                                                      .jamKeluar!
                                                                      .isEmpty)
                                                              ? Colors.green
                                                              : Colors.red,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    record.tglAbsen ??
                                                        "Tanggal -",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    "Masuk: ${record.jamMasuk ?? "-"} | Pulang: ${record.jamKeluar ?? "-"}\nKet: ${record.keterangan ?? "-"}",
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          : Center(
                                            child: Text(
                                              "Belum ada riwayat absensi",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _onRefresh() async {
    await controller.refreshData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    _refreshController.loadComplete();
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    final secondControlPoint = Offset(3 * size.width / 4, size.height - 60);
    final secondEndPoint = Offset(size.width, size.height - 20);
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
