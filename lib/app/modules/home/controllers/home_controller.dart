import 'package:absen_raw/app/data/resnponse/absenhistory.dart';
import 'package:absen_raw/app/data/resnponse/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/endpoint.dart';

class HomeController extends GetxController {
  // Data profil
  var nama = ''.obs;
  var nomorHandphone = ''.obs;
  var jabatan = ''.obs;
  var jamKerja = ''.obs;
  var idKaryawan = ''.obs;
  var isAbsenMasukDone = false.obs;
  var isAbsenPulangDone = false.obs;
  var isLoadingAbsenMasuk = false.obs; // Tambahkan loading absen masuk
  var isLoadingAbsenPulang = false.obs; // Tambahkan loading absen pulang
  // Lokasi
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;

  // Riwayat absensi
  var absenHistoryList = <HistoryAbsen>[].obs;

  late GoogleMapController mapController;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  final InAppUpdate inAppUpdate = InAppUpdate();

  get updateAvailable => null;

  Future<void> checkForUpdate() async {
    final packageInfo =
        (GetPlatform.isAndroid)
            ? await PackageInfo.fromPlatform()
            : PackageInfo(
              appName: '',
              packageName: '',
              version: '',
              buildNumber: '',
            );
    final currentVersion = packageInfo.version;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.flexibleUpdateAllowed) {
        final latestVersion = updateInfo.availableVersionCode.toString();
        if (currentVersion != latestVersion) {
          showUpdateDialog();
        }
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  void showUpdateDialog() {
    Get.defaultDialog(
      title: 'Pembaruan Tersedia',
      content: Column(
        children: [
          const Text(
            'Versi baru aplikasi tersedia. Apakah Anda ingin mengunduh pembaruan sekarang?',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      confirm: InkWell(
        onTap: () async {
          await InAppUpdate.performImmediateUpdate();
          Get.back();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow,
          ),
          child: const Center(
            child: Text(
              'Unduh Sekarang',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Ambil semua data ulang
  Future<void> refreshData() async {
    await fetchProfile();
    await fetchAbsenHistory();
    getCurrentLocation();
  }

  Future<void> fetchProfile() async {
    try {
      Profile profile = await API.profileiD();
      if (profile.data != null) {
        nama.value = profile.data?.namaKaryawan ?? '';
        nomorHandphone.value = profile.data?.hp ?? '';
        jamKerja.value = '08:00 - 17:00';
        idKaryawan.value = profile.data?.id?.toString() ?? '';
      }
      update(); // Perbarui UI setelah mendapatkan data
    } catch (e) {
      print("Error fetchProfile: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("GPS off", "Mohon nyalakan layanan GPS.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Izin ditolak", "Tidak dapat mengambil lokasi.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Izin ditolak permanen", "Izinkan lokasi melalui Settings.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude.value = position.latitude;
    longitude.value = position.longitude;

    try {
      final placemarks = await geo.placemarkFromCoordinates(
        latitude.value,
        longitude.value,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        address.value =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      }
    } catch (e) {
      address.value = "Gagal memuat alamat";
      print("Error reverse geocoding: $e");
    }

    if (mapController != null) {
      final newPos = LatLng(latitude.value, longitude.value);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPos, zoom: 15),
        ),
      );
    }
    update();
  }

  Future<void> fetchAbsenHistory() async {
    try {
      if (idKaryawan.value.isEmpty) return;
      final history = await API.AbsenHistoryID(idkaryawan: idKaryawan.value);

      if (history.status == true) {
        absenHistoryList.value = history.historyAbsen ?? [];

        String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
        isAbsenMasukDone.value = absenHistoryList.any(
          (record) => record.tglAbsen == today && record.jamMasuk != null,
        );
        isAbsenPulangDone.value = absenHistoryList.any(
          (record) => record.tglAbsen == today && record.jamKeluar != null,
        );

        update();
      } else {
        Get.snackbar("Error", history.massage ?? "Gagal memuat riwayat absen");
      }
    } catch (e) {
      print("Error fetchAbsenHistory: $e");
    }
  }

  Future<void> absenMasuk() async {
    try {
      if (isAbsenMasukDone.value) {
        Get.snackbar("Info", "Anda sudah absen masuk hari ini.");
        return;
      }
      final result = await API.AbsenMasukID(
        idkaryawan: idKaryawan.value,
        latitude: latitude.value.toString(),
        longitude: longitude.value.toString(),
      );

      if (result.status?.toLowerCase() == "true") {
        Get.snackbar("Sukses", result.message ?? "Absen masuk berhasil");
        await fetchAbsenHistory();
      } else {
        // Tampilkan pesan error dari response jika absen gagal
        Get.snackbar("Sukses", result.message ?? "Absen masuk gagal");
      }
      update();
    } catch (e) {
      print("Error absenMasuk: $e");
      if (e is DioError && e.response?.statusCode == 400) {
        Get.snackbar(
          "Error",
          e.response?.data['message'] ?? "Terjadi error 400",
        );
      } else {
        Get.snackbar("Error", "Terjadi kesalahan, silahkan coba lagi");
      }
    }
  }

  Future<void> absenPulang() async {
    try {
      if (isAbsenPulangDone.value) {
        Get.snackbar("Info", "Anda sudah absen pulang hari ini.");
        return;
      }
      final lastAbsen = absenHistoryList.first;
      final absenId = lastAbsen.id?.toString() ?? '';
      final result = await API.AbsenPulangID(id: absenId, keterangan: "Pulang");

      if (result.status?.toLowerCase() == "true") {
        Get.snackbar("Sukses", result.message ?? "Absen pulang berhasil");
        await fetchAbsenHistory();
      } else {
        Get.snackbar("Sukses", result.message ?? "Absen pulang gagal");
      }
      update();
    } catch (e) {
      print("Error absenPulang: $e");
    }
  }
}
