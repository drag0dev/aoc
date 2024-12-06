import gleam/yielder
import gleam/dict
import gleam/int
import gleam/list
import gleam/io
import gleam/string
import simplifile

fn check_line(rules: List(#(Int, Int)), line: List(Int)) -> Bool {
  let indices = list.index_fold(line, dict.new(), fn(d, num, index) { dict.insert(d, num, index) })
  list.map(rules, fn(rule) {
    let left_index = case dict.get(indices, rule.0) {
      Ok(i) -> i
      Error(_) -> -1
    }
    let right_index = case dict.get(indices, rule.1) {
      Ok(i) -> i
      Error(_) -> -1
    }

    right_index == -1 || left_index == -1 || {left_index < right_index}
  }) |>
  list.all(fn(valid) {valid})
}

fn part_one(rules: List(#(Int, Int)), lines: List(List(Int))) {
  io.print("Part one: ")
  list.map(lines, fn(line) {
    case check_line(rules, line) {
      True -> {
        let middle = list.length(line) / 2
        let assert Ok(middle) = yielder.from_list(line) |> yielder.at(middle)
        middle
      }
      False -> 0
    }
  }) |>
  list.fold(0, fn(acc, num) {acc+num}) |>
  int.to_string |>
  io.println
}

fn set_find(set: List(Int), num: Int) -> Bool {
  case list.find(set, fn (n) {n == num}) {
      Ok(_) -> True
      _ -> False
    }
}

fn set_insert(set: List(Int), num: Int) -> List(Int) {
  case set_find(set, num) {
    True -> set
    False -> [num, ..set]
  }
}

fn insert_in_order(set: List(Int), line: List(Int), complete_line: List(Int), rules: dict.Dict(Int, List(Int)), num: Int) -> #(List(Int), List(Int)) {
  // if we havent seen this number before
  case set_find(set, num) {
    True -> #(set, line)
    False -> {
      // go through all the numbers that need to be before the current
      let before = case dict.get(rules, num) {
        Ok(before) -> before
        Error(_) -> []
      }
      let #(set, line) = list.fold(before, #(set, line), fn(set_line_pair, num_before) {
          case set_find(complete_line, num_before) {
            True -> insert_in_order(set_line_pair.0, set_line_pair.1, complete_line, rules, num_before)
            False -> #(set_line_pair.0, set_line_pair.1)
          }
      })

      let line = list.append(line, [num])
      let set = set_insert(set, num)
      #(set, line)
    }
  }
}

fn part_two(rules: List(#(Int, Int)), lines: List(List(Int))) {
  let matrix_rules = list.fold(rules, dict.new(), fn(d, pair) {
    case dict.get(d, pair.1) {
      Ok(l) -> dict.insert(d, pair.1, [pair.0, ..l])
      Error(_) -> dict.insert(d, pair.1, [pair.0])
    }
  })
  let invalid_lines = list.filter(lines, fn(line) {!check_line(rules, line)})

  io.print("Part two: ")
  // go through the original line and add it to the new
  list.map(invalid_lines, fn(line) {
    list.fold(line, #([], []), fn(set_line_pair, num) {
      let #(new_set ,new_line) = insert_in_order(set_line_pair.0, set_line_pair.1, line, matrix_rules, num)
      #(new_set, new_line)
    })
  }) |>
  list.map(fn(set_line_pair) {set_line_pair.1}) |>
  list.map(fn(line) {
    let middle = list.length(line) / 2
    let assert Ok(middle) = yielder.from_list(line) |> yielder.at(middle)
    middle
  }) |>
  list.fold(0, fn(acc, num) {acc+num}) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  let assert [rules, lines] = string.split(input, "\n\n")

  let rules = string.split(rules, "\n")
  let lines = string.split(lines, "\n")

  let rules = list.map(rules, fn(rule) {
    let assert [left, right] = string.split(rule, "|")
    let assert Ok(left) = int.parse(left)
    let assert Ok(right) = int.parse(right)
    #(left, right)
  })

  let lines = list.map(lines, fn (line) {
    line |>
    string.split(",") |>
    list.map(fn (num) { let assert Ok(num) = int.parse(num) num })
  })

  part_one(rules, lines)
  part_two(rules, lines)
}
