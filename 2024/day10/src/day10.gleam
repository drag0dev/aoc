import gleam/set
import gleam/result
import gleam/int
import gleam/io
import glearray
import gleam/list
import gleam/string
import simplifile

fn index_matrix(input: glearray.Array(glearray.Array(Int)), x: Int, y: Int) -> Int {
  case glearray.get(input, x) {
    Ok(row) -> {
      case glearray.get(row, y) {
        Ok(num) -> num
        Error(_) -> panic as "unreachable"
      }
    }
    Error(_) -> panic as "unreachable"
  }
}

fn traverse(input: glearray.Array(glearray.Array(Int)), x: Int, y: Int, height: Int, width: Int, expected_ele: Int, peaks: set.Set(#(Int, Int))) -> set.Set(#(Int, Int)) {
  case x >= 0 && x < height && y >= 0 && y < width {
    False -> peaks
    True -> {
      case index_matrix(input, x, y) == expected_ele {
        False -> peaks
        True -> {
          case expected_ele == 9 {
            True -> {
              let peaks = set.insert(peaks, #(x, y))
              peaks
            }
            False -> {
              let peaks = traverse(input, x+1, y, height, width, expected_ele+1, peaks)
              let peaks = traverse(input, x-1, y, height, width, expected_ele+1, peaks)
              let peaks = traverse(input, x, y+1, height, width, expected_ele+1, peaks)
              let peaks = traverse(input, x, y-1, height, width, expected_ele+1, peaks)
              peaks
            }
          }
        }
      }
    }
  }
}

fn part_one(input: glearray.Array(glearray.Array(Int)), height: Int, width: Int) {
  list.range(0, height-1) |>
  list.map(fn(x) {
    list.range(0, width-1) |>
    list.map(fn(y) { #(x, y) })
  }) |>
  list.flatten |>
  list.map(fn(coord) { traverse(input, coord.0, coord.1, height, width, 0, set.new()) }) |>
  list.map(fn(peaks) {set.size(peaks)}) |>
  list.fold(0, fn(acc, trails) {acc+trails}) |>
  int.to_string |>
  io.println
}

fn traverse_part_two(input: glearray.Array(glearray.Array(Int)), x: Int, y: Int, height: Int, width: Int, expected_ele: Int) -> Int {
  case x >= 0 && x < height && y >= 0 && y < width {
    False -> 0
    True -> {
      case index_matrix(input, x, y) == expected_ele {
        False -> 0
        True -> {
          case expected_ele == 9 {
            True -> 1
            False -> {
              traverse_part_two(input, x+1, y, height, width, expected_ele+1) +
              traverse_part_two(input, x-1, y, height, width, expected_ele+1) +
              traverse_part_two(input, x, y+1, height, width, expected_ele+1) +
              traverse_part_two(input, x, y-1, height, width, expected_ele+1)
            }
          }
        }
      }
    }
  }
}

fn part_two(input: glearray.Array(glearray.Array(Int)), height: Int, width: Int) {
  list.range(0, height-1) |>
  list.map(fn(x) {
    list.range(0, width-1) |>
    list.map(fn(y) { #(x, y) })
  }) |>
  list.flatten |>
  list.map(fn(coord) { traverse_part_two(input, coord.0, coord.1, height, width, 0) }) |>
  list.fold(0, fn(acc, trails) {acc+trails}) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  let input = string.split(input, "\n") |>
    list.map(fn (line) {
      string.to_graphemes(line) |>
      list.map(fn(char) { int.parse(char) |> result.unwrap(0) })
    }) |>
    list.map(fn (line) { glearray.from_list(line) })
  let input = glearray.from_list(input)

  let height = glearray.length(input)
  let assert Ok(row) = glearray.get(input, 0)
  let width = glearray.length(row)

  io.print("Part one: ")
  part_one(input, height, width)

  io.print("Part two: ")
  part_two(input, height, width)
}
