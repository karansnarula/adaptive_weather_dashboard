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

  @override
  String get dailyWeatherNotification => 'การแจ้งเตือนสภาพอากาศรายวัน';

  @override
  String get dailyWeatherUpdates => 'คุณจะได้รับข้อมูลสภาพอากาศประจำวัน';

  @override
  String get noNotificationCity => 'ยังไม่ได้ตั้งเมืองสำหรับแจ้งเตือน';

  @override
  String get notificationHint =>
      'แตะไอคอนกระดิ่งบนการ์ดสภาพอากาศเพื่อเปิดใช้งาน';

  @override
  String get mapUnavailable => 'แผนที่ไม่พร้อมใช้งาน';

  @override
  String get chatbot => 'แชทบอท';

  @override
  String get weatherNews => 'ข่าว';

  @override
  String get airQuality => 'คุณภาพอากาศ';

  @override
  String get pollenAllergy => 'เกสรดอกไม้';

  @override
  String get comingSoon => 'เร็วๆ นี้';

  @override
  String get comingSoonMessage =>
      'ฟีเจอร์นี้จะพร้อมใช้งานในการอัปเดตครั้งถัดไป';

  @override
  String get ok => 'ตกลง';

  @override
  String welcomeBack(String name) {
    return 'ยินดีต้อนรับกลับ, $name!';
  }

  @override
  String get aqiGood => 'ดี';

  @override
  String get aqiFair => 'พอใช้';

  @override
  String get aqiModerate => 'ปานกลาง';

  @override
  String get aqiPoor => 'แย่';

  @override
  String get aqiVeryPoor => 'แย่มาก';

  @override
  String get aqiUnknown => 'ไม่ทราบ';

  @override
  String get airQualityIndex => 'ดัชนีคุณภาพอากาศ';

  @override
  String get pollutantLevels => 'ระดับมลพิษ (μg/m³)';

  @override
  String appVersion(String version) {
    return 'เวอร์ชันแอป: $version';
  }

  @override
  String get chatbotPageTitle => 'ผู้ช่วยสภาพอากาศ AI';

  @override
  String get chatbotInputHint => 'ถามเกี่ยวกับสภาพอากาศ…';

  @override
  String get chatbotEmptyStateGeneric =>
      'สวัสดี! ฉันคือผู้ช่วยสภาพอากาศของคุณ ถามฉันได้เกี่ยวกับสภาพภูมิอากาศ การพยากรณ์ หรือเรื่องราวเกี่ยวกับสภาพอากาศที่คุณสงสัย';

  @override
  String chatbotEmptyStateWithCity(String city) {
    return 'สวัสดี! ถามฉันได้เกี่ยวกับสภาพอากาศใน $city หรือสถานที่อื่นๆ';
  }

  @override
  String get chatbotQuotaExceeded =>
      'ครบจำนวนข้อความรายวันแล้ว ลองใหม่พรุ่งนี้';

  @override
  String chatbotQuotaExceededDetail(int limit) {
    return 'คุณใช้ข้อความฟรี $limit ข้อความของวันนี้หมดแล้ว กลับมาใหม่พรุ่งนี้ — เร็วๆ นี้จะมีแพ็กเกจแบบเสียค่าใช้จ่าย';
  }

  @override
  String chatbotQuotaResetAt(String time) {
    return 'รีเซ็ตเวลา $time';
  }

  @override
  String get chatbotError => 'ไม่สามารถเชื่อมต่อผู้ช่วยได้ แตะส่งเพื่อลองใหม่';

  @override
  String get weatherDiscussion => 'พูดคุย';

  @override
  String get discussionFeedTitle => 'พูดคุยเรื่องสภาพอากาศ';

  @override
  String get discussionPostTitle => 'โพสต์';

  @override
  String get discussionAddPost => 'เพิ่มโพสต์';

  @override
  String get discussionSearchCityFirst => 'ค้นหาเมืองก่อนเพื่อโพสต์';

  @override
  String get discussionNoPostsYet => 'ยังไม่มีโพสต์ มาเป็นคนแรกที่แชร์กันเถอะ!';

  @override
  String get discussionNoCommentsYet =>
      'ยังไม่มีความคิดเห็น เริ่มต้นการสนทนากันเถอะ';

  @override
  String get discussionRetry => 'ลองใหม่';

  @override
  String get discussionPostedOn => 'โพสต์เมื่อ:';

  @override
  String discussionByAuthor(String name) {
    return 'โดย $name';
  }

  @override
  String get discussionCreatePostTitle => 'แชร์อัปเดต';

  @override
  String discussionCreatePostUnder(String city) {
    return 'โพสต์ภายใต้ $city';
  }

  @override
  String get discussionTitleLabel => 'หัวข้อ';

  @override
  String get discussionImageUrlLabel => 'URL รูปภาพ (ไม่บังคับ)';

  @override
  String get discussionDescriptionLabel => 'รายละเอียด';

  @override
  String get discussionSubmitPost => 'โพสต์';

  @override
  String get discussionAddComment => 'เพิ่มความคิดเห็น';

  @override
  String get discussionDeletePostTitle => 'ลบโพสต์?';

  @override
  String get discussionDeletePostBody =>
      'การทำเช่นนี้จะลบโพสต์และความคิดเห็นทั้งหมดอย่างถาวร';

  @override
  String get discussionDeleteCommentTitle => 'ลบความคิดเห็น?';

  @override
  String get discussionDeleteCommentBody =>
      'การทำเช่นนี้จะลบความคิดเห็นอย่างถาวร';

  @override
  String get discussionCancel => 'ยกเลิก';

  @override
  String get discussionDelete => 'ลบ';

  @override
  String get eventStorm => 'พายุ';

  @override
  String get eventFlood => 'น้ำท่วม';

  @override
  String get eventHeatwave => 'คลื่นความร้อน';

  @override
  String get eventDrought => 'ภัยแล้ง';

  @override
  String get eventWildfire => 'ไฟป่า';

  @override
  String get eventTornado => 'ทอร์นาโด';

  @override
  String newsPageTitle(String city) {
    return 'ข่าว $city';
  }

  @override
  String get newsTabWeather => 'สภาพอากาศ';

  @override
  String get newsTabGeneral => 'ทั่วไป';

  @override
  String get newsTabTravel => 'ท่องเที่ยว';

  @override
  String get newsNoArticles => 'ไม่พบบทความ';

  @override
  String get newsError => 'โหลดข่าวไม่สำเร็จ ดึงลงเพื่อลองใหม่';

  @override
  String get newsRetry => 'ลองใหม่';

  @override
  String get newsErrorOpening => 'ไม่สามารถเปิดบทความได้';

  @override
  String get newsNotAvailableOnWeb =>
      'ฟีเจอร์นี้ไม่มีให้ใช้งานบนเว็บ ลองใช้แอปบนมือถือ';

  @override
  String get profileUploadTitle => 'อัปโหลดรูปโปรไฟล์';

  @override
  String get profileTakePhoto => 'ถ่ายภาพ';

  @override
  String get profileSelectFromGallery => 'เลือกจากแกลเลอรี';

  @override
  String get profileDeleteCurrent => 'ลบรูปปัจจุบัน';

  @override
  String get profileCancel => 'ยกเลิก';

  @override
  String get profileDropZoneIdle => 'ลากรูปภาพมาที่นี่เพื่ออัปโหลด';

  @override
  String get profileDropZoneHover => 'ปล่อยเพื่ออัปโหลด';

  @override
  String get profileDropZoneClickToBrowse => 'หรือคลิกเพื่อเลือกไฟล์';

  @override
  String get profileDropZoneHint => 'PNG, JPG, WebP · ขนาดสูงสุด 2MB';

  @override
  String get profileInvalidFile => 'กรุณาวางไฟล์รูปภาพ';

  @override
  String get profileUpdated => 'อัปเดตโปรไฟล์แล้ว';
}
