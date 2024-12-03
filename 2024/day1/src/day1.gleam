import gleam/dict
import gleam/io
import gleam/list
import gleam/string
import gleam/int
import simplifile

fn get_one_side(pair: String, left: Bool) -> Int {
  let assert [left_num, right_num] = string.split(pair, "   ")
  let number = case left {
        True -> left_num
        False -> right_num
    }
  let assert Ok(number) = int.parse(number)
  number
}

fn get_one_column(list: List(String), left: Bool) -> List(Int) {
  case list {
    [first, ..rest] -> [get_one_side(first, left), ..get_one_column(rest, left)]
    [] -> []
  }
}

fn part_one(left_column: List(Int), right_column: List(Int)) {
  list.zip(left_column, right_column) |>
  list.map(fn(pair) {int.absolute_value(pair.0 - pair.1)}) |>
  list.fold(0, fn(acc, a) {acc + a}) |>
  int.to_string |>
  io.println
}

fn generate_freq(numbers) {
  list.fold(numbers, dict.new(), fn (d, num) {
        case dict.get(d, num) {
            Ok(freq) -> dict.insert(d, num, freq+1)
            Error(_) -> dict.insert(d, num, 1)
          }
    })
}

fn part_two(left_column: List(Int), right_column: List(Int)) {
  let right_freq = generate_freq(right_column)

  list.fold(left_column, 0, fn (acc, num) {
    case dict.get(right_freq, num) {
        Ok(right_freq) -> acc + {num * right_freq}
        Error(_) -> {acc}
      }
  }) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let numbers = string.split(input, "\n") |> list.reverse() |> list.drop(1) |> list.reverse()
  let left_column = get_one_column(numbers, True) |> list.sort(int.compare)
  let right_column = get_one_column(numbers, False) |> list.sort(int.compare)

  // part one
  io.print("Part one: ")
  part_one(left_column, right_column)

  // part two
  io.print("Part two: ")
  part_two(left_column, right_column)
}
