import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TicTacToe()),
          );
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_to_drive_outlined,
                size: 100,
              ),
              SizedBox(height: 10),
              Text(
                'TIC TAC TOE GAME',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> grid = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  bool isCrossTurn = true; // true if it's cross's turn, false for zero's turn

  void _onBlockTapped(int row, int col) {
    if (grid[row][col] == '') {
      setState(() {
        grid[row][col] = isCrossTurn ? 'X' : 'O';
        isCrossTurn = !isCrossTurn;

        // Check for a winner after each move
        String winner = _checkWinner();
        if (winner != '') {
          // Display winner message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Game Over'),
                content: Text('$winner wins!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              );
            },
          );
        } else if (_checkDraw()) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'GAME OVER!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text('GAME DRAW!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _resetGame();
                      },
                      child: const Text('PLAY AGAIN!'),
                    )
                  ],
                );
              });
        }
      });
    }
  }

  String _checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (grid[i][0] == grid[i][1] &&
          grid[i][1] == grid[i][2] &&
          grid[i][0] != '') {
        return grid[i][0];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (grid[0][i] == grid[1][i] &&
          grid[1][i] == grid[2][i] &&
          grid[0][i] != '') {
        return grid[0][i];
      }
    }

    // Check diagonals
    if (grid[0][0] == grid[1][1] &&
        grid[1][1] == grid[2][2] &&
        grid[0][0] != '') {
      return grid[0][0];
    }
    if (grid[0][2] == grid[1][1] &&
        grid[1][1] == grid[2][0] &&
        grid[0][2] != '') {
      return grid[0][2];
    }

    return ''; // No winner yet
  }

  bool _checkDraw() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[i][j] == '') {
          return false; // There are still empty cells, not a draw yet
        }
      }
    }
    return true; // All cells are filled, it's a draw
  }

  void _resetGame() {
    setState(() {
      // Clear the grid and reset the turn
      grid = [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ];
      isCrossTurn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        automaticallyImplyLeading:
            false, //For removing the back arrow from app bar.
        title: const Center(
          child: Text(
            'TIC TAC TOE',
            style: TextStyle(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                backgroundColor: Colors.black),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/tictactoe.png'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int j = 0; j < 3; j++)
                      GestureDetector(
                        onTap: () => _onBlockTapped(i, j),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            border: Border.all(color: Colors.black, width: 05),
                          ),
                          child: Center(
                            child: Text(
                              grid[i][j],
                              style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
