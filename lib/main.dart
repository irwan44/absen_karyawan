import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/data/localstorage.dart'; // file LocalStorages Anda
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi get_storage
  await GetStorage.init('token-mekanik');
  await GetStorage.init('preferences-mekanik');

  // Cek apakah ada token
  bool hasToken = await LocalStorages.hasToken();

  // Tentukan initialRoute
  String initialRoute = hasToken ? Routes.HOME : Routes.LOGIN;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
