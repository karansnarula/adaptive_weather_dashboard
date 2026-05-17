// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'แดชบอร์ดสภาพอากาศ';

  @override
  String get navWeather => 'สภาพอากาศ';

  @override
  String get navFavorites => 'รายการโปรด';

  @override
  String get navSettings => 'ตั้งค่า';

  @override
  String get searchCity => 'ค้นหาเมือง...';

  @override
  String get temperature => 'อุณหภูมิ';

  @override
  String get humidity => 'ความชื้น';

  @override
  String get windSpeed => 'ความเร็วลม';

  @override
  String feelsLike(String temp) {
    return 'รู้สึกเหมือน $temp°';
  }

  @override
  String get forecast => 'พยากรณ์อากาศ 5 วัน';

  @override
  String get favorites => 'เมืองโปรด';

  @override
  String get noFavorites => 'ยังไม่มีเมืองโปรด';

  @override
  String get addedToFavorites => 'เพิ่มในรายการโปรดแล้ว';

  @override
  String get removedFromFavorites => 'ลบออกจากรายการโปรดแล้ว';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get units => 'หน่วย';

  @override
  String get celsius => 'เซลเซียส';

  @override
  String get fahrenheit => 'ฟาเรนไฮต์';

  @override
  String get errorGeneric => 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';

  @override
  String get errorNoInternet => 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต';

  @override
  String get errorCityNotFound => 'ไม่พบเมืองที่ค้นหา กรุณาลองใหม่';

  @override
  String get searchPrompt => 'ค้นหาเมืองเพื่อดูสภาพอากาศ';

  @override
  String get feelsLikeLabel => 'รู้สึกเหมือน';

  @override
  String get fiveDayForecast => 'พยากรณ์อากาศ 5 วัน';

  @override
  String get tapToViewWeather => 'แตะเพื่อดูสภาพอากาศ';

  @override
  String get noFavoritesSubtitle => 'ค้นหาเมืองแล้วแตะหัวใจเพื่อบันทึก';

  @override
  String get temperatureUnit => 'หน่วยอุณหภูมิ';

  @override
  String get switchToFahrenheit => 'เปลี่ยนเป็นฟาเรนไฮต์';

  @override
  String get switchToCelsius => 'เปลี่ยนเป็นเซลเซียส';

  @override
  String get authErrorEmailInUse => 'มีบัญชีที่ใช้อีเมลนี้อยู่แล้ว';

  @override
  String get authErrorInvalidEmail => 'ที่อยู่อีเมลไม่ถูกต้อง';

  @override
  String get authErrorWeakPassword =>
      'รหัสผ่านไม่ปลอดภัยเพียงพอ ใช้อย่างน้อย 6 ตัวอักษร';

  @override
  String get authErrorUserNotFound => 'ไม่พบบัญชีที่ใช้อีเมลนี้';

  @override
  String get authErrorWrongPassword => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get authErrorInvalidCredential => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get authErrorGeneric => 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get theme => 'ธีม';

  @override
  String get lightMode => 'โหมดสว่าง';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get systemMode => 'ตามระบบ';
}
