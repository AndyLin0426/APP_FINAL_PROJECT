import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

Color myBackgroundColor = Color(0xFFFFD9EC);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // 啟動畫面
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 點擊螢幕後切換到遊戲畫面
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/photo2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.0),
                Text(
                  '終極密碼',
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Text(
                  '點擊螢幕開始遊戲',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _maxNumber = 0;
  int _secretNumber = 0;
  int? _userGuess;
  int _attempts = 0;
  TextEditingController _controller = TextEditingController();
  String _resultText = '';
  String _resultText2='';
  int lowerBound = 0;
  int upperBound = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    lowerBound = 0;
    _maxNumber += 100;
    upperBound = _maxNumber;
    _secretNumber = Random().nextInt(_maxNumber) + 1;
    _userGuess = null;
    _attempts = 0;
    _controller.clear();
    _resultText = '';
    _resultText2='';
  }

  void _resetGame() {
    lowerBound = 0;
    _maxNumber = 0;
    _maxNumber += 100;
    upperBound = _maxNumber;
    _secretNumber = Random().nextInt(_maxNumber) + 1;
    _userGuess = null;
    _attempts = 0;
    _controller.clear();
    _resultText = '';
    _resultText2='';
  }

  void _checkGuess() {
    setState(() {
      if (_userGuess == null) {
        _showResultDialog('請輸入數字');
      } else {
        _attempts++;

        if (_userGuess! < _secretNumber) {
          _resultText = '太小了，再試一次！';
          if (_userGuess! < lowerBound) {
            lowerBound = lowerBound;
          } else {
            lowerBound = _userGuess!;
          }
        } else if (_userGuess! > _secretNumber) {
          _resultText = '太大了，再試一次！';
          if (_userGuess! > upperBound) {
            upperBound = upperBound;
          } else {
            upperBound = _userGuess!;
          }
        } else {
          _showResultDialog('恭喜你猜對了！共猜了 $_attempts 次');
          _startNewGame();
          return;
        }

        _resultText2 = '範圍：$lowerBound~$upperBound';
        _controller.clear();
      }
    });
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('遊戲結果'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('確定'),
            ),
          ],
        );
      },
    );
  }

  String get _currentLevel =>
      (((_maxNumber - 100) / 100) + 1).ceil().toString();

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('終極密碼遊戲 - 第 $_currentLevel 關'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/photo3.jpg'), // 更改為你的背景圖片路徑
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_resultText',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.pinkAccent),
              ),
              Text(
                '$_resultText2',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.pinkAccent),
              ),
              Text(
                '猜一個 $_maxNumber 以內的數字',
                style: TextStyle(fontSize: 25.0,color: Colors.red),
              ),
              TextField(

                controller: _controller,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _userGuess = int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: '輸入你的猜測',
                  labelStyle: TextStyle(color: Colors.red),
                ),
                style: TextStyle(color: Colors.pinkAccent), // 更改使用者輸入文字的顏色,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _checkGuess();
                },
                child: Text('確認猜測'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _resetGame();
                },
                child: Text('重新開始'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}