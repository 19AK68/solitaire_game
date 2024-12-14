import 'package:flutter/material.dart';

class SolitaireGamesScreen extends StatefulWidget {
  const SolitaireGamesScreen({super.key});

  @override
  State<SolitaireGamesScreen> createState() => _SolitaireGamesScreenState();
}

class _SolitaireGamesScreenState extends State<SolitaireGamesScreen> {
  // Начальная позиция игрового поля
  final List<List<int>> initialBoard = [
    [-1, -1, 1, 1, 1, -1, -1],
    [-1, -1, 1, 1, 1, -1, -1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 0, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [-1, -1, 1, 1, 1, -1, -1],
    [-1, -1, 1, 1, 1, -1, -1],
  ];

  // Текущее игровое поле
  late List<List<int>> board;

  // Хранение выбранной ячейки
  int? selectedRow;
  int? selectedCol;

  @override
  void initState() {
    super.initState();
    resetBoard();
  }

  // Метод для сброса игрового поля
  void resetBoard() {
    setState(() {
      board = initialBoard.map((row) => List<int>.from(row)).toList();
      selectedRow = null;
      selectedCol = null;
    });
  }

  // Метод обработки нажатия на ячейку
  void onCellTap(int row, int col) {
    setState(() {
      if (board[row][col] == 1) {
        // Если нажата ячейка с шариком, выделяем её
        selectedRow = row;
        selectedCol = col;
      } else if (board[row][col] == 0 &&
          selectedRow != null &&
          selectedCol != null) {
        // Если нажата пустая ячейка и есть выделенный шарик
        if (isValidMove(selectedRow!, selectedCol!, row, col)) {
          // Делаем ход: перемещаем шарик
          board[row][col] = 1; // Новая позиция шарика
          board[selectedRow!][selectedCol!] = 0; // Старая позиция пустая
          int midRow = (selectedRow! + row) ~/ 2;
          int midCol = (selectedCol! + col) ~/ 2;
          board[midRow][midCol] = 0; // Убираем "перепрыгнутый" шарик

          // Сбрасываем выделение
          selectedRow = null;
          selectedCol = null;
        }
      } else {
        // Если нажата невалидная ячейка — снимаем выделение
        selectedRow = null;
        selectedCol = null;
      }
    });
  }

  // Проверка: допустим ли ход
  bool isValidMove(int fromRow, int fromCol, int toRow, int toCol) {
    // Ход возможен, только если ячейка на 2 позиции по горизонтали или вертикали
    if ((fromRow == toRow && (fromCol - toCol).abs() == 2) ||
        (fromCol == toCol && (fromRow - toRow).abs() == 2)) {
      // Между ними должен быть шарик
      int midRow = (fromRow + toRow) ~/ 2;
      int midCol = (fromCol + toCol) ~/ 2;
      if (board[midRow][midCol] == 1) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solitaire Game")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // Размер сетки 7x7
                ),
                itemCount: 49,
                itemBuilder: (context, index) {
                  int row = index ~/ 7;
                  int col = index % 7;

                  // Определяем тип ячейки
                  if (board[row][col] == -1) {
                    // Ячейка вне поля
                    return const SizedBox.shrink();
                  }

                  // Цвет для выделенной ячейки
                  bool isSelected = row == selectedRow && col == selectedCol;

                  return GestureDetector(
                    onTap: () {
                      onCellTap(row, col); // Обработка нажатия
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: board[row][col] == 1
                            ? (isSelected ? Colors.green : Colors.blue) // Шарик
                            : Colors.grey.shade300, // Пустая ячейка
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Кнопка "Начать сначала"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: resetBoard, // Сброс игрового поля
              child: const Text("Начать сначала"),
            ),
          ),
        ],
      ),
    );
  }
}
