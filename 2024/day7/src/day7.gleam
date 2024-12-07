import gleam/int
import gleam/list
import gleam/io
import gleam/string
import simplifile

fn check_eq_step(line: List(Int), sum: Int, target) -> Bool {
  case sum > target {
    True -> False
    False -> {
      case line {
        [first, ..rest] -> {
          check_eq_step(rest, sum+first, target) ||
          check_eq_step(rest, sum*first, target)
        }
        [] -> target == sum
      }
    }
  }
}

fn check_eq(line: List(Int)) -> Bool {
  let assert [target, first, second, ..rest] = line

  check_eq_step(rest, first+second, target) ||
  check_eq_step(rest, first*second, target)
}

fn part_one(input: List(List(Int))) {
  list.map(input, fn(line) {
    case check_eq(line) {
      False -> 0
      True -> {
        let assert [first, .._rest] = line
        first
      }
    }
  }) |>
  list.fold(0, fn(acc, sum) {acc+sum}) |>
  int.to_string |>
  io.println
}

fn pow(base: Int, expo: Int, total: Int) -> Int {
  case expo {
    0 -> total
    _ -> pow(base, expo-1, total*base)
  }
}

fn combine_number(left: Int, right: Int) -> Int {
  let assert Ok(digits) = int.digits(right, 10)
  let right_len = list.length(digits)
  left*pow(10, right_len-1, 10) + right
}

fn check_eq_step_with_concat(line: List(Int), sum: Int, target) -> Bool {
  case sum > target {
    True -> False
    False -> case line {
      [first, ..rest] -> {
        check_eq_step_with_concat(rest, sum+first, target) ||
        check_eq_step_with_concat(rest, sum*first, target) ||
        check_eq_step_with_concat(rest, combine_number(sum, first), target)
      }
      [] -> target == sum
    }
  }
}

fn check_eq_with_concat(line: List(Int)) -> Bool {
  let assert [target, first, second, ..rest] = line

  check_eq_step_with_concat(rest, first+second, target) ||
  check_eq_step_with_concat(rest, first*second, target) ||
  check_eq_step_with_concat(rest, combine_number(first, second), target)
}

fn part_two(input: List(List(Int))) {
  list.map(input, fn(line) {
    case check_eq_with_concat(line) {
      False -> 0
      True -> {
        let assert [first, .._rest] = line
        first
      }
    }
  }) |>
  list.fold(0, fn(acc, sum) {acc+sum}) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  let input = string.split(input, "\n") |>
    list.map(fn (line) { string.replace(line, ":", "") }) |>
    list.map(fn (line) { string.split(line, " ") }) |>
    list.map(fn (line) {
      list.map(line, fn (num) {
        let assert Ok(num) = int.parse(num)
        num
      })
    })

  io.print("Part one: ")
  part_one(input)
  io.print("Part two: ")
  part_two(input)
}
