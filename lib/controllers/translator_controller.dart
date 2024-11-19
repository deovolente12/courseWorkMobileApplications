import 'package:coursework_jongsungkim/services/translator_service.dart';

class TranslatorController {
  static Future<String> translateText(String text, String sourceLanguage, String targetLanguage) async {
    return await TranslatorService.translateText(text, sourceLanguage, targetLanguage);
  }
}
