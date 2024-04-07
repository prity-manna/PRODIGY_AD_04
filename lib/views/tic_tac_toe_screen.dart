import 'dart:async';

import 'package:flutter/material.dart';

class TicTacToeScreen extends StatefulWidget {
  final bool isSinglePlayer;
  final String userMarker;
  const TicTacToeScreen({super.key, required this.isSinglePlayer, required this.userMarker});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {

  late List<List<String>> _board;
  late String _currentPlayer;
  late String? _winner;
  late bool _gameEnded;
  late bool _isComputerPlaying;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(3, (i) => List.filled(3, ''));
    _currentPlayer = widget.userMarker;
    _winner = null;
    _gameEnded = false;
    _isComputerPlaying = false;
  }

  void _resetGame() {
    setState(() {
      _initializeBoard();
    });
  }

 void _placeMark(int row, int col) {
  if (_board[row][col] == '' && _winner == null && !_isComputerPlaying) {
    setState(() {
      _board[row][col] = _currentPlayer;
      _checkWinner();
      if (widget.isSinglePlayer && _currentPlayer == widget.userMarker && _winner == null) {
        _isComputerPlaying = true;
        _togglePlayer();
        Timer(const Duration(milliseconds: 1500), () {
          _computerMove();
          _isComputerPlaying = false;
        });
      } else {
        _togglePlayer();
      }
    });
  }
}

  void _togglePlayer() {
    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
  }

  String? _getWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != '' && _board[i][0] == _board[i][1] && _board[i][1] == _board[i][2]) {
        return _board[i][0];
      }
    }
    for (int i = 0; i < 3; i++) {
      if (_board[0][i] != '' && _board[0][i] == _board[1][i] && _board[1][i] == _board[2][i]) {
        return _board[0][i];
      }
    }
    if (_board[0][0] != '' && _board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) {
      return _board[0][0];
    }
    if (_board[0][2] != '' && _board[0][2] == _board[1][1] && _board[1][1] == _board[2][0]) {
      return _board[0][2];
    }
    return null;
  }

  void _checkWinner() {
    if (_gameEnded) {
      return;
    }
    String? winner = _getWinner();
    if (winner != null) {
      _showWinnerAnimation(winner);
      _gameEnded = true;
      return;
    }
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          isDraw = false;
          break;
        }
      }
      if (!isDraw) break;
    }
    if (isDraw) {
      _showDrawAnimation();
      _gameEnded = true;
    }
  }

  void _showWinnerAnimation(String winner) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Winner'),
          content: Text('Player $winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

void _showDrawAnimation() async {
  // Implement animation to display draw message
  // For simplicity, we'll just show a draw message in a dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Draw'),
        content: const Text('It\'s a draw!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  if (!mounted) return;
  Navigator.pop(context);
}

  void _computerMove() {
    // Find available spots
    List<int> availableSpots = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          availableSpots.add(i * 3 + j);
        }
      }
    }
    // Randomly select an available spot
    if (availableSpots.isNotEmpty) {
      int randomIndex = availableSpots[DateTime.now().millisecondsSinceEpoch % availableSpots.length];
      if (!mounted) return;
      setState(() => _isComputerPlaying = false);
      _placeMark(randomIndex ~/ 3, randomIndex % 3);
    }
  }

  Widget _buildGameButton(int row, int col) {
    return GestureDetector(
      onTap: () => _placeMark(row, col),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (j) {
            return _buildGameButton(i, j);
          }),
        );
      }),
    );
  }

  @override
  void dispose() {
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
          children: [
            _buildGameBoard(),
            const SizedBox(height: 20),
            Text(
              'Current Player: $_currentPlayer',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.redAccent)
              ),
              child: const Text('Reset Game', style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}