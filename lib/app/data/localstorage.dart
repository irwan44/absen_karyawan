import 'package:absen_raw/app/data/publik.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorages {
  static GetStorage boxToken = GetStorage('token-mekanik');
  static GetStorage boxPreferences = GetStorage('preferences-mekanik');

  // Token handling
  static Future<bool> hasToken() async {
    String token = getToken;
    return token.isNotEmpty;
  }

  static Future<void> setToken(String token) async {
    await boxToken.write('token', token);
    Publics.controller.getToken.value = getToken;
  }

  static String get getToken => boxToken.read('token') ?? '';

  static Future<void> deleteToken() async {
    await boxToken.remove('token');
    Publics.controller.getToken.value = ''; // Set token kosong setelah dihapus
  }

  // Keep me signed in handling
  static Future<void> setKeepMeSignedIn(bool keepSignedIn) async {
    await boxPreferences.write('keepMeSignedIn', keepSignedIn);
  }

  static Future<bool> getKeepMeSignedIn() async {
    return boxPreferences.read('keepMeSignedIn') ?? false;
  }

  static Future<void> deleteKeepMeSignedIn() async {
    await boxPreferences.remove('keepMeSignedIn');
  }

  // Posisi handling
  static Future<void> setPosisi(dynamic posisi) async {
    await boxPreferences.write('posisi', posisi);
  }

  static dynamic get getPosisi => boxPreferences.read('posisi');

  static Future<void> deletePosisi() async {
    await boxPreferences.remove('posisi');
  }

  // Logout: hapus token, keep me signed in, dan posisi
  static Future<void> logout() async {
    await deleteToken();
    await deleteKeepMeSignedIn();
    await deletePosisi();
    // Tambahkan logika logout lainnya jika diperlukan
  }
}
