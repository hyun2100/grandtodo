import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final TextEditingController _controller = TextEditingController();
  SharedPreferences? _prefs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String savedMemo = _prefs?.getString('memo') ?? '';
    setState(() {
      _controller.text = savedMemo;
      _isLoading = false;
    });
  }

  Future<void> _saveMemo(String memo) async {
    if (_prefs != null) {
      await _prefs!.setString('memo', memo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        backgroundColor: const Color.fromARGB(255, 144, 238, 144),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '메 모',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        style: const TextStyle(fontSize: 50, color: Colors.black),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '메모를 입력하세요...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (text) {
                          _saveMemo(text);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      minimumSize: const Size.fromHeight(70),
                    ),
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
