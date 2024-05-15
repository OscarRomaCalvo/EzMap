import 'package:flutter_tts/flutter_tts.dart';

class TextReader {
  static final FlutterTts flutterTts = FlutterTts();

  static Future<void> speak(String text) async {
    await flutterTts.setLanguage('es-ES');
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }
}