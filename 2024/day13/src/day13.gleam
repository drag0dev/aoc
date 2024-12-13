import gleam/int
import gleam/list
import gleam/io
import gleam/string
import simplifile

fn find_cheapest(option_a: #(Int, Int), option_b: #(Int, Int), target: #(Int, Int)) -> Int {
  let det = option_a.0 * option_b.1 - option_a.1 * option_b.0
  let a = { target.0 * option_b.1 - target.1 * option_b.0 } / det
  let b = { target.1 * option_a.0 - target.0 * option_a.1 } / det
  case #(option_a.0 * a + option_b.0 * b, option_a.1 * a + option_b.1 * b) == target {
    True -> b + 3 * a
    False -> 0
  }
}

fn part_one(input: List(List(#(Int, Int)))) {
  io.print("Part one: ")
  list.map(input, fn(problem) {
    let assert [option_a, option_b, target] = problem
    find_cheapest(option_a, option_b, target)
  }) |>
  list.fold(0, fn(acc, tokens) { acc + tokens }) |>
  int.to_string |>
  io.println
}

fn part_two(input: List(List(#(Int, Int)))) {
  io.print("Part one: ")
  list.map(input, fn(problem) {
    let assert [option_a, option_b, target] = problem
    let target = #(target.0 + 10000000000000, target.1 + 10000000000000)
    find_cheapest(option_a, option_b, target)
  }) |>
  list.fold(0, fn(acc, tokens) { acc + tokens }) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.replace("Button A: ", "") |>
    string.replace("Button B: ", "") |>
    string.replace("X+", "") |>
    string.replace(" Y+", "") |>
    string.replace("Prize: X=", "") |>
    string.replace(" Y=", "") |>
    string.split("\n\n") |>
    list.map(fn (problem) {
      problem |>
      string.split("\n") |>
      list.map(fn (line) {
        let assert [x, y] = string.split(line, ",") |>
        list.map(fn (num) {
          let assert Ok(num) = int.parse(num)
          num
        })
        #(x, y)
      })
    })

  part_one(input)
  part_two(input)
}
