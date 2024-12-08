import gleam/int
import gleam/set
import gleam/dict
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn find_antennas(input: List(List(String))) -> dict.Dict(String, List(#(Int, Int))) {
  list.index_fold(input, dict.new(), fn(d, row, x) {
    list.index_fold(row, d, fn(d_inner, letter, y) {
      case letter == "." {
        True -> d_inner
        False -> {
          case dict.get(d_inner, letter) {
            Ok(rest) -> dict.insert(d_inner, letter, [#(x, y), ..rest])
            Error(_) -> dict.insert(d_inner, letter, [#(x, y)])
          }
        }
      }
    })
  })
}

fn create_antinodes_each(current: #(Int, Int), coords: List(#(Int, Int)), antinodes: set.Set(#(Int, Int))) -> set.Set(#(Int, Int)) {
  case coords {
    [other, ..rest] -> {
      case current.1 < other.1 {
        // parallel to main diagonal
        True -> {
          let x_diff = -{current.0 - other.0}
          let y_diff = -{current.1 - other.1}
          let antinodes = set.insert(antinodes, #(current.0 - x_diff, current.1 - y_diff))
          let antinodes = set.insert(antinodes, #(other.0 + x_diff, other.1 + y_diff))
          create_antinodes_each(current, rest, antinodes)
        }
        False -> {
          let x_diff = -{current.0 - other.0}
          let y_diff = current.1 - other.1
          let antinodes = set.insert(antinodes, #(current.0 - x_diff, current.1 + y_diff))
          let antinodes = set.insert(antinodes, #(other.0 + x_diff, other.1 - y_diff))
          create_antinodes_each(current, rest, antinodes)
        }
      }
    }
    [] -> antinodes
  }
}

fn create_antinodes(coords: List(#(Int, Int)), antinodes: set.Set(#(Int, Int))) -> set.Set(#(Int, Int)) {
  case coords {
    [first, ..rest] -> {
      let antinodes = create_antinodes_each(first, rest, antinodes)
      create_antinodes(rest, antinodes)
    }
    [] -> antinodes
  }
}

fn part_one(input: List(List(String)), height: Int, width: Int) {
  let antennas = find_antennas(input) |>
  dict.map_values(fn (_key, coords) { list.reverse(coords) }) // revrse in order to have antennas appear left to right top to bottom

  dict.keys(antennas) |>
  list.fold(set.new(), fn(antinodes, key) {
    let assert Ok(coords) = dict.get(antennas, key)
    create_antinodes(coords, antinodes)
  }) |>
  set.to_list |>
  list.filter(fn(pair) {
    let #(x, y) = pair
    x >= 0 && x < height && y >= 0 && y < width
  }) |>
  list.length |>
  int.to_string |>
  io.println
}

fn insert_antinodes_while_in_matrix(start: #(Int, Int), x_diff: Int, y_diff: Int, antinodes: set.Set(#(Int, Int)), height: Int, width: Int) -> set.Set(#(Int, Int)) {
  let new_x = start.0 + x_diff
  let new_y = start.1 + y_diff
  case new_x >= 0 && new_x < height && new_y >= 0 && new_y < width {
    True -> {
      let antinodes = set.insert(antinodes, #(new_x, new_y))
      insert_antinodes_while_in_matrix(#(new_x, new_y), x_diff, y_diff, antinodes, height, width)
    }
    False -> antinodes
  }
}

fn create_antinodes_each_part_two(current: #(Int, Int), coords: List(#(Int, Int)), antinodes: set.Set(#(Int, Int)), height: Int, width: Int) -> set.Set(#(Int, Int)) {
  case coords {
    [other, ..rest] -> {
      case current.1 < other.1 {
        // parallel to main diagonal
        True -> {
          let x_diff = -{current.0 - other.0}
          let y_diff = -{current.1 - other.1}
          let antinodes = insert_antinodes_while_in_matrix(current, -x_diff, -y_diff, antinodes, height, width)
          let antinodes = insert_antinodes_while_in_matrix(current, x_diff, y_diff, antinodes, height, width)
          create_antinodes_each_part_two(current, rest, antinodes, height, width)
        }
        False -> {
          let x_diff = -{current.0 - other.0}
          let y_diff = current.1 - other.1
          let antinodes = insert_antinodes_while_in_matrix(current, -x_diff, y_diff, antinodes, height, width)
          let antinodes = insert_antinodes_while_in_matrix(current, x_diff, -y_diff, antinodes, height, width)
          create_antinodes_each_part_two(current, rest, antinodes, height, width)
        }
      }
    }
    [] -> antinodes
  }
}

fn create_antinodes_part_two(coords: List(#(Int, Int)), antinodes: set.Set(#(Int, Int)), height: Int, width: Int) -> set.Set(#(Int, Int)) {
  case coords {
    [first, ..rest] -> {
      let antinodes = create_antinodes_each_part_two(first, rest, antinodes, height, width)
      let antinodes = set.insert(antinodes, first)
      create_antinodes_part_two(rest, antinodes, height, width)
    }
    [] -> antinodes
  }
}

fn part_two(input: List(List(String)), height: Int, width: Int) {
  let antennas = find_antennas(input) |>
  dict.map_values(fn (_key, coords) { list.reverse(coords) }) // revrse in order to have antennas appear left to right top to bottom

  dict.keys(antennas) |>
  list.fold(set.new(), fn(antinodes, key) {
    let assert Ok(coords) = dict.get(antennas, key)
    create_antinodes_part_two(coords, antinodes, height, width)
  }) |>
  set.size |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  let input = string.split(input, "\n") |>
  list.map(fn(line) { string.to_graphemes(line) })

  let height = list.length(input)
  let assert Ok(row) = list.first(input)
  let width = list.length(row)

  io.print("Part one: ")
  part_one(input, height, width)
  io.print("Part one: ")
  part_two(input, height, width)
}
