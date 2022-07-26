import 'package:recook/pages/life_service/sudoku_start_game_page.dart';

class SudokuModel {
  late  List<List<dynamic>> puzzle;
  late List<List<dynamic>> solution;

  SudokuModel({required this.puzzle, required this.solution});

  SudokuModel.fromJson(Map<String, dynamic> json) {
    if (json['puzzle'] != null) {
      puzzle = [];
      json['puzzle'].forEach((v) { puzzle.add(v); });
    }
    if (json['solution'] != null) {
      solution = [];
      json['solution'].forEach((v) { solution.add(v); });
    }
  }

}

class IntModel {
  late List<dynamic> puzzle;

  IntModel({required this.puzzle});

  IntModel.fromJson(Map<String, dynamic> json) {
    puzzle = json['puzzle'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['puzzle'] = this.puzzle;
    return data;
  }
}


class SudokuDealModel{
  late  List<IntDealModel> puzzle;

  SudokuDealModel({
    required this.puzzle,
  });
}

class IntDealModel{
  late List<OneModel> list;

  IntDealModel({
    required this.list,
  });
}


