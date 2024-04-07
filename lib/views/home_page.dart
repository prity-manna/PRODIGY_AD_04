import 'package:flutter/material.dart';
import 'package:tictactoe/views/tic_tac_toe_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String _selectedMarker;

  @override
  void initState() {
    super.initState();
    _selectedMarker = "X";
  }

  @override
  void dispose() {
    _selectedMarker = "";
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tic_tac_toe_logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'X',
                        groupValue: _selectedMarker,
                        onChanged: (value) {
                          setState(() {
                            _selectedMarker = value!;
                          });
                        },
                      ),
                      const Text('Play as X'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'O',
                        groupValue: _selectedMarker,
                        onChanged: (value) {
                          setState(() {
                            _selectedMarker = value!;
                          });
                        },
                      ),
                      const Text('Play as O'),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicTacToeScreen(isSinglePlayer: true, userMarker: _selectedMarker)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Play Against Computer',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicTacToeScreen(isSinglePlayer: false, userMarker: _selectedMarker,)),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Play Multiplayer',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}