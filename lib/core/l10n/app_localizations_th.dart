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
}
