import 'package:get/get.dart';

import '../modules/cuti/bindings/cuti_binding.dart';
import '../modules/cuti/views/cuti_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/izin/bindings/izin_binding.dart';
import '../modules/izin/views/izin_view.dart';
import '../modules/lembur/bindings/lembur_binding.dart';
import '../modules/lembur/views/lembur_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(name: _Paths.IZIN, page: () => IzinView(), binding: IzinBinding()),
    GetPage(name: _Paths.CUTI, page: () => CutiView(), binding: CutiBinding()),
    GetPage(
      name: _Paths.LEMBUR,
      page: () => LemburView(),
      binding: LemburBinding(),
    ),
  ];
}
