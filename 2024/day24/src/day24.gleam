import gleam/int
import gleam/result
import gleam/list
import gleam/io
import gleam/string
import gleam/dict
import simplifile

fn apply_operation(left: Int, right: Int, operator: String) -> Int {
  case operator {
    "AND" -> int.bitwise_and(left, right)
    "OR" -> int.bitwise_or(left, right)
    "XOR" -> int.bitwise_exclusive_or(left, right)
    _ -> panic as "unreachable"
  }
}

fn try_update_state(operations: List(List(String)), state: dict.Dict(String, Int), not_processed: List(List(String))) -> #(List(List(String)), dict.Dict(String, Int)) {
  case operations {
    [] -> #(not_processed, state)
    [operation, ..rest] -> {
      let assert [left, operator, right, destination] = operation

      let left = dict.get(state, left) |> result.unwrap(-1)
      let right = dict.get(state, right) |> result.unwrap(-1)
      case left != -1 && right != -1 {
        False -> try_update_state(rest, state, [operation, ..not_processed])
        True -> {
          let value = apply_operation(left, right, operator)
          let state = dict.insert(state, destination, value)
          try_update_state(rest, state, not_processed)
        }
      }
    }
  }
}

fn update_states(operations: List(List(String)), state: dict.Dict(String, Int)) -> dict.Dict(String, Int) {
  case list.length(operations) {
    0 -> state
    _ -> {
      let #(operations, state) = try_update_state(operations, state, [])
      update_states(operations, state)
    }
  }
}

fn part_one(operations: List(List(String)), state: dict.Dict(String, Int)) {
  io.print("Part one: ")

  update_states(operations, state) |>
  dict.to_list |>
  list.filter(fn(pair) {
    let #(name, _value) = pair
    string.starts_with(name, "z")
  }) |>
  list.sort(fn(left, right) {
    let #(left_name, _) = left
    let #(right_name, _) = right
    string.compare(left_name, right_name)
  }) |>
  list.fold("", fn(acc, state) {
    let #(_, state) = state
    let str_state = case state {
      0 -> "0"
      1 -> "1"
      _ -> panic as "unreachable"
    }
    str_state <> acc
  }) |>
  int.base_parse(2) |>
  result.unwrap(-1) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  let assert [base, logic] = string.split(input, "\n\n")

  let wire_states = string.split(base, "\n") |>
    list.fold(dict.new(), fn(acc, state) {
      let assert [name, state] = string.split(state, ": ")
      let assert Ok(state) = int.parse(state)
      dict.insert(acc, name, state)
    })

  let operations = string.split(logic, "\n") |>
    list.map(fn (operation) {
      let operation = string.replace(operation, "-> ", "")
      string.split(operation, " ")
    })

  part_one(operations, wire_states)
}
