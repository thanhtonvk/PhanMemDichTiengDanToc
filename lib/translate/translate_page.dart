import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  State<StatefulWidget> createState() {
    return TranslateState();
  }
}

class TranslateState extends State<Translate> {
  SpeechToText _speechToText = SpeechToText();
  late FlutterTts flutterTts;
  bool _speechEnabled = false;
  String _lastWords = '';

  String _sourceLanguage = 'Kinh';
  String _targetLanguage = 'Pà Thẻn';
  String _inputText = '';
  String _translateText = '';
  final List<String> _languages = [
    'Kinh',
    'Anh',
    'Pà Thẻn',
    'Dao',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    flutterTts = FlutterTts();
    _setupTTS();
  }

  Future<void> _setupTTS() async {
    await flutterTts.setLanguage("vi-VN"); // Tiếng Việt
    await flutterTts.setSpeechRate(0.7); // Tốc độ nói
    await flutterTts.setPitch(1.0); // Cao độ
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (error) => print("Error: $error"),
      onStatus: (status) => print("Status: $status"),
    );
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'vi_VN');
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void _translate() {
    // Thay thế bằng API dịch thực sự nếu cần
    setState(() {
      _translateText = "Dịch: $_inputText ($_sourceLanguage -> $_targetLanguage)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HỆ THỐNG HỖ TRỢ GIAO TIẾP CHO NGƯỜI DÂN TỘC',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _sourceLanguage,
                    isExpanded: true,
                    items: _languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sourceLanguage = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _targetLanguage,
                    isExpanded: true,
                    items: _languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _targetLanguage = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nhập nội dung cần dịch',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (text) {
                setState(() {
                  _inputText = text;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _translate,
              child: const Text('Dịch'),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _translateText.isEmpty
                    ? 'Kết quả dịch sẽ hiển thị tại đây.'
                    : _translateText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_translateText.isNotEmpty) {
                  _speak(_translateText); // Đọc nội dung dịch
                }
              },
              child: const Text('Phát âm nội dung dịch'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
