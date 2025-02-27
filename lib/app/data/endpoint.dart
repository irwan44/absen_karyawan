import 'dart:convert';

import 'package:absen_raw/app/data/publik.dart';
import 'package:absen_raw/app/data/resnponse/absenhistory.dart';
import 'package:absen_raw/app/data/resnponse/abseninfo.dart';
import 'package:absen_raw/app/data/resnponse/absenmnasuk.dart';
import 'package:absen_raw/app/data/resnponse/login.dart';
import 'package:absen_raw/app/data/resnponse/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../routes/app_pages.dart';
import 'localstorage.dart';

class API {
  static const _url = 'https://apps-mobile.techthinkhub.com';
  static const _baseUrl = '$_url/api';
  static const _getLogin = '$_baseUrl/mekanik/login';
  static const _getProfile = '$_baseUrl/mekanik/profile-karyawan';
  static const _getdetailapsen = '$_baseUrl/mekanik/absen';
  static const _postAbsen = '$_baseUrl/mekanik/absen/insert';
  static const _getHistotyapsen = '$_baseUrl/mekanik/absen/history';
  static const _getPulang = '$_baseUrl/mekanik/absen/update';
  //Dio profile
  static Future<Token> login({
    required String email,
    required String password,
  }) async {
    final data = {"email": email, "password": password};

    try {
      var response = await http.post(
        Uri.parse(_getLogin),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response Data: $responseData'); // Debug print seluruh response

        if (responseData['status'] == false) {
          Get.snackbar(
            'Error',
            responseData['message'],
            backgroundColor: const Color(0xffe5f3e7),
          );
          return Token(status: false);
        } else {
          final obj = Token.fromJson(responseData);
          if (obj.token != null) {
            // Simpan token
            await LocalStorages.setToken(obj.token!);

            // Ambil dan simpan data posisi dari objek karyawan
            if (obj.data != null &&
                obj.data!.karyawan != null &&
                obj.data!.karyawan!.posisi != null) {
              await LocalStorages.setPosisi(obj.data!.karyawan!.posisi);
              print(
                'Data posisi berhasil disimpan di local: ${obj.data!.karyawan!.posisi}',
              );
            } else {
              print('Data posisi tidak ditemukan dalam response');
            }

            Get.snackbar(
              'Selamat Datang',
              'REAL AUTO WOKSHOP',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.snackbar(
              'Error',
              'Token tidak ditemukan',
              backgroundColor: const Color(0xffe5f3e7),
            );
          }
          print('Login successful. Response data: ${obj.toJson()}');
          return obj;
        }
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error during login: $e');
      throw e;
    }
  }

  //Dio profile
  static Future<Profile> profileiD() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getProfile,
        options: Options(headers: {"Content-Type": "application/json"}),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        return Profile(
          status: false,
          message: "Tidak ada data booking untuk karyawan ini.",
        );
      }

      final obj = Profile.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(obj.message.toString(), obj.message.toString());
      }
      return obj;
    } catch (e) {
      throw e;
    }
  }

  //Dio absen
  static Future<Absen> InfoAbsenID() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getdetailapsen,
        options: Options(headers: {"Content-Type": "application/json"}),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = Absen.fromJson(response.data);

      if (obj.message == null) {
        throw Exception("Data Mekanik kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }

  //Dio History absen
  static Future<AbsenHistory> AbsenHistoryID({
    required String idkaryawan,
  }) async {
    final data = {"id_karyawan": idkaryawan};
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');

      var response = await Dio().get(
        _getHistotyapsen,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      print('Response: ${response.data}');
      final obj = AbsenHistory.fromJson(response.data);
      if (obj.massage == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(obj.massage.toString(), obj.massage.toString());
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  static Future<AbsenMasuk> AbsenMasukID({
    required String idkaryawan,
    required String latitude,
    required String longitude,
  }) async {
    final data = {
      "id_karyawan": idkaryawan,
      "latitude": latitude,
      "longitude": longitude,
    };
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');
      var response = await Dio().post(
        _postAbsen,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');
      final obj = AbsenMasuk.fromJson(response.data);
      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar(obj.message.toString(), obj.message.toString());
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  static Future<AbsenMasuk> AbsenPulangID({
    required String id,
    required String keterangan,
  }) async {
    final data = {"id": id, "keterangan": keterangan};
    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token');
      var response = await Dio().post(
        _getPulang,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}');
      final obj = AbsenMasuk.fromJson(response.data);
      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar(obj.message.toString(), obj.message.toString());
      }
      return obj;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
