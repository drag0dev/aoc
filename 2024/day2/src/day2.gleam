import gleam/order
import gleam/io
import gleam/int
import gleam/list
import gleam/string
import simplifile

fn parse_report(report_line: String) -> List(Int) {
  string.split(report_line, " ") |>
  list.map(fn (num_str) {
      let assert Ok(num) = int.parse(num_str)
      num
    })
}


fn map_report_part_one(report: List(Int)) -> Bool {
  let assert Ok(#(a, b)) = list.window_by_2(report) |> list.first()
  case int.compare(a, b) {
      order.Gt -> is_report_valid(report, order.Gt)
      order.Lt -> is_report_valid(report, order.Lt)
      order.Eq -> False
    }
}

fn is_report_valid(report: List(Int), order: order.Order) -> Bool {
  let invalid_pair_count = report |>
    list.window_by_2() |>
    list.map(fn (pair) {
          let diff = int.absolute_value(pair.0 - pair.1)
          int.compare(pair.0, pair.1) == order && diff >= 1 && diff <= 3
      }) |>
      list.count(fn(valid) {!valid})

  invalid_pair_count == 0
}


fn map_report_part_two(report: List(List(Int))) -> Bool {
  list.any(report, fn(report) {
    let assert Ok(#(a, b)) = list.window_by_2(report) |> list.first()
    case int.compare(a, b) {
        order.Gt -> is_report_valid(report, order.Gt)
        order.Lt -> is_report_valid(report, order.Lt)
        order.Eq -> False
      }
    })
}

// function required for part two, just generate all possible reports with one
// element dropped optionally
fn generate_with_one_missing(report: List(Int), dropped: Bool, current: List(Int)) -> List(List(Int)) {
  case report {
    [one, ..rest] -> {
        let drop = case dropped {
            True -> []
            False -> generate_with_one_missing(rest, True, current)
          }
        let not_dropped = generate_with_one_missing(rest, dropped, [one, ..current])
        list.append(drop, not_dropped)
      }
    [] -> [list.reverse(current)]
  }
}

fn part_one(reports: List(List(Int))) {
  list.map(reports, map_report_part_one) |>
  list.count(fn (el) {el}) |>
  int.to_string |>
  io.println
}

fn part_two(reports: List(List(Int))) {
  list.map(reports, generate_with_one_missing(_, False, [])) |>
  list.map(map_report_part_two) |>
  list.count(fn (valid) {valid}) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let reports = string.split(input, "\n") |> list.reverse() |> list.drop(1) |> list.reverse()
  let reports = list.map(reports, parse_report)
  io.print("Part one: ")
  part_one(reports)
  io.print("Part two: ")
  part_two(reports)
}
