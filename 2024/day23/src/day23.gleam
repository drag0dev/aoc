import gleam/set
import gleam/int
import gleam/io
import gleam/dict
import gleam/list
import gleam/string
import simplifile

fn check_combination(combination: List(String), edges: set.Set(#(String, String))) -> Bool {
  let assert [first, second, third] = combination
  let atleast_one_with_t = list.fold(combination, False, fn(acc, computer) { string.starts_with(computer, "t") || acc })
  let first_to_second = set.contains(edges, #(first, second))
  let first_to_third = set.contains(edges, #(first, third))
  let second_to_third = set.contains(edges, #(second, third))
  first_to_second && first_to_third && second_to_third && atleast_one_with_t
}

fn part_one(computers: List(String), edges: set.Set(#(String, String))) {
  io.print("Part one: ")
  list.combinations(computers, 3) |>
  list.map(fn(combination) { check_combination(combination, edges) }) |>
  list.count(fn (is_valid) { is_valid }) |>
  int.to_string |>
  io.println
}

fn can_fit(target: String, current_set: List(String), edges: set.Set(#(String, String))) -> Bool {
  list.fold_until(current_set, True, fn(_, current_comp) {
    case set.contains(edges, #(target, current_comp)) {
      True -> list.Continue(True)
      False -> list.Stop(False)
    }
  })
}

fn find_longest(edges: set.Set(#(String, String)), current: List(String), computers: List(String)) -> List(String) {
  case computers {
    [] -> current
    [computer, ..rest] -> {
      case can_fit(computer, current, edges) {
        False -> find_longest(edges, current, rest)
        True -> {
          let without = find_longest(edges, current, rest)
          let with = find_longest(edges, [computer, ..current], rest)
          let without_size = list.length(without)
          let with_size = list.length(with)
          case with_size > without_size {
            True -> with
            False -> without
          }
        }
      }
    }
  }
}

fn part_two(computers: List(String), edges: set.Set(#(String, String))) {
  io.print("Part one: ")
  find_longest(edges, [], computers) |>
  list.sort(string.compare) |>
  list.fold("", fn(acc, computer) { acc <> "," <> computer }) |>
  string.drop_start(1) |>
  io.println

}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let edges = string.trim_end(input) |>
    string.split("\n") |>
    list.map(fn (line) {
      let assert [left, right] = string.split(line, "-")
      #(left, right)
    })

  let computers = list.fold(edges, dict.new(), fn(acc, line) {
      let #(left, right) = line
      let acc = case dict.get(acc, left) {
        Error(_) -> dict.insert(acc, left, [right])
        Ok(edges) -> dict.insert(acc, left, [right, ..edges])
      }
      case dict.get(acc, right) {
        Error(_) -> dict.insert(acc, right, [left])
        Ok(edges) -> dict.insert(acc, right, [left, ..edges])
      }
    }) |>
    dict.keys

  let edges = list.fold(edges, set.new(), fn(acc, edge) {
    let #(left, right) = edge
    let acc = set.insert(acc, #(left, right))
    set.insert(acc, #(right, left))
  })

  part_one(computers, edges)
  part_two(computers, edges)
}
