import gleam/int
import gleam/list
import gleam/io
import gleam/string
import gleam/yielder
import simplifile

fn index_matrix(matrix: List(List(String)), x: Int, y: Int) -> String {
  case x >= 0 && y >= 0 {
    True -> case yielder.from_list(matrix) |> yielder.at(x) {
      Ok(line) -> {
        case yielder.from_list(line) |> yielder.at(y)  {
          Ok(char) -> char
            Error(_) -> " "
        }
      }
      Error(_) -> " "
    }

    False -> " "
  }
}

// part one
fn horizontal(input: List(String), word: String) -> Int {
  list.map(input, fn(line){string.replace(line, word, "~")}) |>
  list.map(fn(line) {string.to_graphemes(line)}) |>
  list.map(fn(line) {list.count(line, fn(char) {char == "~"})}) |>
  list.fold(0, fn (acc, count) {acc+count})
}


fn check_main_diagonal(input: List(List(String)), x: Int, y: Int, word: String) -> Bool {
  string.to_graphemes(word) |>
  list.index_map(fn (char, idx) { #(char, x+idx, y+idx) }) |>
  list.map(fn(tuple) {
    index_matrix(input, tuple.1, tuple.2) == tuple.0
  }) |>
  list.all(fn (letter_matched) {letter_matched})
}

fn main_diagonal(input: List(List(String)), word: String, width: Int, height: Int) -> Int {
    list.range(0, height) |>
    list.map(fn (x) {
      list.range(0, width) |>
      list.map(fn (y) {#(x, y)})
    }) |>
    list.flatten() |>
    list.map(fn(coordinates) {
      check_main_diagonal(input, coordinates.0, coordinates.1, word)}) |>
    list.count(fn(match) {match})
}

fn check_other_diagonal(input: List(List(String)), x: Int, y: Int, word: String) -> Bool {
  string.to_graphemes(word) |>
  list.index_map(fn (char, idx) { #(char, x+idx, y-idx) }) |>
  list.map(fn(tuple) {
    index_matrix(input, tuple.1, tuple.2) == tuple.0
  }) |>
  list.all(fn (letter_matched) {letter_matched})
}

fn other_diagonal(input: List(List(String)), word: String, width: Int, height: Int) -> Int {
    list.range(0, height) |>
    list.map(fn (x) {
      list.range(0, width) |>
      list.map(fn (y) {#(x, y)})
    }) |>
    list.flatten() |>
    list.map(fn(coordinates) { check_other_diagonal(input, coordinates.0, coordinates.1, word)}) |>
    list.count(fn(match) {match})
}

fn part_one(input: List(String), input_matrix: List(List(String)), width: Int, height: Int) {
  let input_transposed = input_matrix |>
    list.transpose() |>
    list.map(fn (line) {string.concat(line)})

  let horizontal_count = horizontal(input, "XMAS")
  let reverse_horizontal_count = horizontal(input, "SAMX")
  let horizontal_count_transposed = horizontal(input_transposed, "XMAS")
  let reverse_count_transposed = horizontal(input_transposed, "SAMX")
  let diagonal_count = main_diagonal(input_matrix, "XMAS", width, height)
  let reverse_diagonal_count = main_diagonal(input_matrix, "SAMX", width, height)
  let other_diagonal_count = other_diagonal(input_matrix, "XMAS", width, height)
  let other_reverse_diagonal_count = other_diagonal(input_matrix, "SAMX", width, height)
  {horizontal_count + reverse_horizontal_count + horizontal_count_transposed +
    reverse_count_transposed + diagonal_count + reverse_diagonal_count + other_diagonal_count +
    other_reverse_diagonal_count} |>
  int.to_string |>
  io.println
}

// part two
fn check_cross(input: List(List(String)), x: Int, y: Int) -> Bool {
  case index_matrix(input, x, y) == "A" {
    False -> False
    True -> {
      let assert Ok(bottom_left) =  index_matrix(input, x+1, y-1) |> string.to_utf_codepoints() |> list.first()
      let bottom_left = string.utf_codepoint_to_int(bottom_left)
      let assert Ok(top_right) =  index_matrix(input, x-1, y+1) |> string.to_utf_codepoints() |> list.first()
      let top_right = string.utf_codepoint_to_int(top_right)
      let count = case int.absolute_value(bottom_left - top_right) {
        6 -> 1
        _ -> 0
      }

      let assert Ok(bottom_right) =  index_matrix(input, x+1, y+1) |> string.to_utf_codepoints() |> list.first()
      let bottom_right = string.utf_codepoint_to_int(bottom_right)
      let assert Ok(top_left) =  index_matrix(input, x-1, y-1) |> string.to_utf_codepoints() |> list.first()
      let top_left = string.utf_codepoint_to_int(top_left)
      let count = case int.absolute_value(bottom_right - top_left) {
        6 -> count + 1
        _ -> 0
      }
      count == 2
    }
  }
}

fn cross(input: List(List(String)), width: Int, height: Int) -> Int {
    list.range(0, height) |>
    list.map(fn (x) {
      list.range(0, width) |>
      list.map(fn (y) {#(x, y)})
    }) |>
    list.flatten() |>
    list.map(fn(coordinates) {
      check_cross(input, coordinates.0, coordinates.1)}) |>
    list.count(fn(valid) {valid})
}

fn part_two(input: List(List(String)), width: Int, height: Int) {
  cross(input, width, height) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.split("\n")

  let height = list.length(input)
  let assert Ok(row) = yielder.at(yielder.from_list(input), 0)
  let width = row |> string.length

  let input_matrix = input |> list.map(fn (line) {string.to_graphemes(line)})

  io.print("Part one: ")
  part_one(input, input_matrix, width, height)
  io.print("Part two: ")
  part_two(input_matrix, width, height)
}
