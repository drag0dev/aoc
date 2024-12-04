import gleam/int
import gleam/list
import gleam/io
import gleam/regexp
import gleam/string
import simplifile

fn part_one(input: String) {
  let assert Ok(r) = regexp.from_string("mul\\(\\d{1,3},\\d{1,3}\\)")
  regexp.scan(r, input) |>
  list.map(fn (match) {match.content}) |>
  list.map(fn (match) {string.drop_end(match, 1)}) |>
  list.map(fn (match) {string.replace(match, "mul(", "")}) |>
  list.map(fn (match) {string.split(match, ",")}) |>
  list.map(fn (match) {
      let assert [left, right] = match
      let assert Ok(left) = int.parse(left)
      let assert Ok(right) = int.parse(right)
      left * right
    }) |>
  list.fold(0, fn(acc, num) {acc + num}) |>
  int.to_string |>
  io.println
}

fn part_two(input: String) {
  let assert Ok(r) = regexp.from_string("mul\\(\\d{1,3},\\d{1,3}\\)|do\\(\\)|don't\\(\\)")
  let res = regexp.scan(r, input) |>
  list.map(fn (match) {match.content}) |>
  list.map(fn (match) {string.drop_end(match, 1)}) |>
  list.map(fn (match) {string.replace(match, "mul(", "")}) |>
  list.map(fn (match) {string.split(match, ",")}) |>
  list.map(fn (match) {
    case match {
      [left, right] -> {
        let assert Ok(left) = int.parse(left)
        let assert Ok(right) = int.parse(right)
        left * right
      }
      [instruction] -> {
          case instruction {
              "don't(" -> -2
              "do(" -> -1
              _ -> panic as "unreachable"
            }
      }
      _ -> panic as "unreachable"
    }
  }) |>
  list.fold(#(True, 0), fn(acc, num) {
    case num {
      -1 -> #(True, acc.1)
      -2 -> #(False, acc.1)
      num -> {
        case acc.0 {
          True -> #(acc.0, acc.1 + num)
          False -> #(acc.0, acc.1)
        }
      }
    }
  })

  res.1 |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  io.print("Part one: ")
  part_one(input)
  io.print("Part two: ")
  part_two(input)
}
