import gleam/int
import gleam/list
import gleam/string
import gleam/io
import simplifile
import gleamy/set
import gleam/order
import glearray

fn compare_tuples(left: #(Int, Int), right: #(Int, Int)) -> order.Order {
  case int.compare(left.0, right.0) {
    order.Eq -> int.compare(left.1, right.1)
    o -> o
  }
}

fn compare_tuples_three(left: #(Int, Int, Int), right: #(Int, Int, Int)) -> order.Order {
  case int.compare(left.0, right.0) {
    order.Eq -> {
      case int.compare(left.1, right.1) {
        order.Eq -> int.compare(left.2, right.2)
        o -> o
      }
    }
    o -> o
  }
}

fn index_matrix(matrix: glearray.Array(glearray.Array(String)), x: Int, y: Int) -> String {
  case glearray.get(matrix, x) {
    Ok(row) -> {
      case glearray.get(row, y) {
        Ok(c) -> c
        Error(_) -> "0"
      }
    }
    Error(_) -> "0"
  }
}

fn index_matrix_with_barrier(matrix: glearray.Array(glearray.Array(String)), x: Int, y: Int, barrier_x: Int, barrier_y: Int) -> String {
  case x == barrier_x && y == barrier_y {
    True -> "#"
    False -> {
      case glearray.get(matrix, x) {
        Ok(row) -> {
          case glearray.get(row, y) {
            Ok(c) -> c
            Error(_) -> "0"
          }
        }
        Error(_) -> "0"
      }
    }
  }
}

fn find_start(map: List(List(String))) -> #(Int, Int) {
  list.index_fold(map, #(-1, -1), fn(acc, line, x) {
    let #(y, found) = list.fold_until(line, #(0, False), fn(pair, char) {
      case char == "^" {
        True -> list.Stop(#(pair.0, True))
        False -> list.Continue(#(pair.0+1, False))
      }
    })
    case found {
      True -> #(x, y)
      False -> acc
    }
  })
}

fn mark(set: set.Set(#(Int, Int)), x_target: Int, y_target: Int) -> set.Set(#(Int, Int)) {
  set.insert(set, #(x_target, y_target))
}

// direction:
// 1 - up
// 2 - down
// 3 - right
// 4 - left
fn traverse(map: glearray.Array(glearray.Array(String)), x: Int, y: Int, direction: Int, visited: set.Set(#(Int, Int))) -> set.Set(#(Int, Int)) {
  let char_in_front = case direction {
    1 -> index_matrix(map, x-1, y)
    2 -> index_matrix(map, x+1, y)
    3 -> index_matrix(map, x, y+1)
    4 -> index_matrix(map, x, y-1)
    _ -> panic as "unreachable"
  }

  let visited = mark(visited, x, y)
  case char_in_front {
    "0" -> visited
    "." -> {
      case direction {
        1 -> traverse(map, x-1, y, direction, visited)
        2 -> traverse(map, x+1, y, direction, visited)
        3 -> traverse(map, x, y+1, direction, visited)
        4 -> traverse(map, x, y-1, direction, visited)
        _ -> panic as "unreachable"
      }
    }
    "#" -> {
      case direction {
        1 -> traverse(map, x, y+1, 3, visited)
        2 -> traverse(map, x, y-1, 4, visited)
        3 -> traverse(map, x+1, y, 2, visited)
        4 -> traverse(map, x-1, y, 1, visited)
        _ -> panic as "unreachable"
        }
    }
    _ -> panic as "unreachable"
  }
}

fn part_one(map: glearray.Array(glearray.Array(String)), start_x: Int, start_y: Int) {
  traverse(map, start_x, start_y, 1, set.new(compare_tuples)) |>
  set.count() |>
  int.to_string |>
  io.println
}

// direction:
// 0 - up
// 1 - right
// 2 - down
// 3 - left
fn traverse_with_limit(map: glearray.Array(glearray.Array(String)), x: Int, y: Int, direction: Int, previous_states: set.Set(#(Int, Int, Int)), barrier_x: Int, barrier_y: Int, visited: set.Set(#(Int, Int))) -> Bool {
  let direction = case direction <= 3 {
    True -> direction
    False -> 0
  }
  case set.contains(previous_states, #(x, y, direction)){
    True -> True
    False -> {
      let char_in_front = case direction {
        0 -> index_matrix_with_barrier(map, x-1, y, barrier_x, barrier_y)
        1 -> index_matrix_with_barrier(map, x, y+1, barrier_x, barrier_y)
        2 -> index_matrix_with_barrier(map, x+1, y, barrier_x, barrier_y)
        3 -> index_matrix_with_barrier(map, x, y-1, barrier_x, barrier_y)
        _ -> panic as "unreachable"
      }

      let previous_states = set.insert(previous_states, #(x, y, direction))
      let visited = mark(visited, x, y)
      case char_in_front {
        "0" -> False
        "." -> {
          case direction {
            0 -> traverse_with_limit(map, x-1, y, direction, previous_states, barrier_x, barrier_y, visited)
            1 -> traverse_with_limit(map, x, y+1, direction, previous_states, barrier_x, barrier_y, visited)
            2 -> traverse_with_limit(map, x+1, y, direction, previous_states, barrier_x, barrier_y, visited)
            3 -> traverse_with_limit(map, x, y-1, direction, previous_states, barrier_x, barrier_y, visited)
            _ -> panic as "unreachable"
          }
        }
        "#" -> traverse_with_limit(map, x, y, direction+1, previous_states, barrier_x, barrier_y, visited)
        _ -> panic as "unreachable"
      }
    }
  }
}

fn part_two(map: glearray.Array(glearray.Array(String)), start_x: Int, start_y: Int) {
  let coordinates = traverse(map, start_x, start_y, 1, set.new(compare_tuples))
  set.to_list(coordinates) |>
  list.filter(fn (coords) { coords.0 != start_x || coords.1 != start_y }) |>
  list.map(fn(barrier_coords) {traverse_with_limit(map, start_x, start_y, 0, set.new(compare_tuples_three), barrier_coords.0,
    barrier_coords.1, set.new(compare_tuples))}) |>
  list.count(fn(is_loop) {is_loop}) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)

  let matrix_input = string.split(input, "\n") |>
    list.map(fn(line) {string.to_graphemes(line)})

  let #(start_x, start_y) = find_start(matrix_input)

  let matrix_input = list.map(matrix_input, fn(line) {
    list.map(line, fn(char) { case char { "^" -> "." c -> c } })
  })

  let array_input = list.map(matrix_input, fn (line){ glearray.from_list(line) }) |> glearray.from_list

  io.print("Part one: ")
  part_one(array_input, start_x, start_y)
  io.print("Part two: ")
  part_two(array_input, start_x, start_y)
}
