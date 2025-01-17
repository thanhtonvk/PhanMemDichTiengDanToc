import 'dart:ui';
import 'package:dich_tieng_dan_toc/common.dart';
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

  List<String> listSource = Common.kinh;
  List<String> listTarget = Common.pathen;
  String _inputText = '';
  String _translateText = '';
  bool toWords = false;
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
    _setupTTS('vi-VN');
    inputNoiDung = TextEditingController(text: _inputText);
  }

  Future<void> _setupTTS(String lang) async {
    await flutterTts.setLanguage(lang); // Tiếng Việt
    await flutterTts.setSpeechRate(0.6); // Tốc độ nói
    await flutterTts.setPitch(1.0); // Cao độ
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      if (_targetLanguage == 'Anh') {
        _setupTTS('en-US');
      } else {
        _setupTTS('vi-VN');
      }
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

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _inputText = _lastWords;
      inputNoiDung.text = _inputText;
      _translate();
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  late TextEditingController inputNoiDung;

  void _translate() {
    setState(() {
      _translateText = "";
      _inputText = inputNoiDung.text.toLowerCase().trim();

      if (toWords) {
        for (String word in _inputText.split(" ")) {
          bool isExist = false;
          for (int i = 0; i < listSource.length; i++) {
            if (listSource[i].toLowerCase() == word.toLowerCase()) {
              _translateText += "${listTarget[i].toLowerCase()} ";
              isExist = true;
              break;
            }
          }
          if (!isExist) {
            _translateText += "${word.toLowerCase()} ";
          }
        }
      } else {
        for (int i = 0; i < listSource.length; i++) {
          if (listSource[i].toLowerCase().trim() == _inputText) {
            _translateText += "${listTarget[i].toLowerCase()} ";
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HPL - HỖ TRỢ GIAO TIẾP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'HỆ THỐNG HỖ TRỢ GIAO TIẾP CHO NGƯỜI DÂN TỘC PÀ THẺN VÀ DAO TRÊN ĐỊA BÀN HUYỆN LÂM BÌNH',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
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
                        if (_sourceLanguage == 'Kinh') {
                          listSource = Common.kinh;
                        }
                        if (_sourceLanguage == 'Anh') {
                          listSource = Common.anh;
                        }
                        if (_sourceLanguage == 'Pà Thẻn') {
                          listSource = Common.pathen;
                        }
                        if (_sourceLanguage == 'Dao') {
                          listSource = Common.dao;
                        }
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
                        if (_targetLanguage == 'Kinh') {
                          listTarget = Common.kinh;
                        }
                        if (_targetLanguage == 'Anh') {
                          listTarget = Common.anh;
                        }
                        if (_targetLanguage == 'Pà Thẻn') {
                          listTarget = Common.pathen;
                        }
                        if (_targetLanguage == 'Dao') {
                          listTarget = Common.dao;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: inputNoiDung,
              decoration: const InputDecoration(
                labelText: 'Nhập nội dung cần dịch',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Câu', style: TextStyle(fontSize: 18)),
                Switch(
                  value: toWords,
                  onChanged: (value) {
                    setState(() {
                      toWords = value; // Cập nhật giá trị toWords trực tiếp
                    });
                  },
                ),
                Text('Từ', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: listSource.length,
              itemBuilder: (BuildContext context, int index) {
                final item = listSource[index];
                return ListTile(
                    leading: const Icon(
                      Icons.text_snippet,
                      color: Colors.blue,
                    ),
                    title: Text(item));
              },
            ))
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
