import gleam/int
import gleam/set
import glearray
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn index_matrix(input: glearray.Array(glearray.Array(String)), x: Int, y: Int) -> String {
  case glearray.get(input, x) {
    Ok(row) -> {
      case glearray.get(row, y) {
        Ok(char) -> char
        Error(_) -> panic as "unreachable"
      }
    }
    Error(_) -> panic as "unreachable"
  }
}

// #(is_new, found, number_of_fences, visited)
pub fn traverse(input: glearray.Array(glearray.Array(String)), x: Int, y: Int, target_plant: String, visited: set.Set(#(Int, Int))) -> #(Bool, Int, Int, set.Set(#(Int, Int))) {
  let current_plant = index_matrix(input, x, y)
  case current_plant == target_plant {
    True -> {
      case set.contains(visited, #(x, y)) {
        False -> {
          let visited = set.insert(visited, #(x, y))

          let directions = [#(1, 0), #(-1, 0), #(0, 1), #(0, -1)]
          let #(number_of_found, number_of_fences, visited)  = list.fold(directions, #(0, 0, visited), fn(acc, direction) {
            let #(number_of_found, number_of_fences, visited) = acc
            let #(x_change, y_change) = direction
            let #(is_new, new_found, new_number_of_fences, visited) = traverse(input, x+x_change, y+y_change, target_plant, visited)

            let #(number_of_found, number_of_fences) = case is_new {
              True -> {
                case new_found > 0 {
                  True -> #(number_of_found+new_found, number_of_fences+new_number_of_fences)
                  False -> #(number_of_found, number_of_fences+1)
                }
              }
              False -> {
                #(number_of_found, number_of_fences)
              }
            }
            #(number_of_found, number_of_fences, visited)
          })

          #(True, number_of_found+1, number_of_fences, visited)
        }
        True -> {
          #(False, 0, 0, visited)
        }
      }
    }
    False -> #(True, 0, 0, visited)
  }
}

pub fn part_one(input: glearray.Array(glearray.Array(String)), height: Int, width: Int) {
  let #(_visited, total) = list.range(1, height) |>
  list.fold([], fn(acc, x) {
    list.range(1, width) |>
    list.fold(acc, fn(acc_inner, y) {[#(x, y), ..acc_inner]})
  }) |>
  list.reverse |>
  list.fold(#(set.new(), 0), fn(acc, coords) {
    let #(x, y) = coords
    let #(visited, total) = acc
    let target_plant = index_matrix(input, x, y)
    let #(_, number_of_found, number_of_fences, visited) = traverse(input, x, y, target_plant, visited)
    #(visited, total+{number_of_found*number_of_fences})
  })
  total |>
  int.to_string |>
  io.println
}

pub fn traverse_part_two(input: glearray.Array(glearray.Array(String)), x: Int, y: Int, target_plant: String, all_visited: set.Set(#(Int, Int)), visited: set.Set(#(Int, Int)))
-> #(set.Set(#(Int, Int)), set.Set(#(Int, Int))) {

  let current_plant = index_matrix(input, x, y)
  case current_plant == target_plant {
    True -> {
      case set.contains(visited, #(x, y)) {
        True -> #(all_visited, visited)
        False -> {
          let visited = set.insert(visited, #(x, y))
          let all_visited = set.insert(all_visited, #(x, y))
          let #(all_visited, visited) = traverse_part_two(input, x+1, y, target_plant, all_visited, visited)
          let #(all_visited, visited) = traverse_part_two(input, x-1, y, target_plant, all_visited, visited)
          let #(all_visited, visited) = traverse_part_two(input, x, y+1, target_plant, all_visited, visited)
          let #(all_visited, visited) = traverse_part_two(input, x, y-1, target_plant, all_visited, visited)
          #(all_visited, visited)
        }
      }
    }
    False -> #(all_visited, visited)
  }
}

pub fn vertical_edge(y: Int, compare_orientation: Int, height: Int, width: Int, rectangle: set.Set(#(Int, Int))) -> Int {
  case y > height+1 || y < 0 {
    True -> 0
    False -> {
      let #(edge_count, edge_detected) = list.range(0, width) |>
      list.fold(#(0, False), fn(acc, x) {
        let #(edge_count, edge_detected) = acc
        let current_is_rectangle = set.contains(rectangle, #(x, y))
        let next_is_rectangle = set.contains(rectangle, #(x, y+compare_orientation))

        case edge_detected {
          False -> {
            case !current_is_rectangle && next_is_rectangle {
              True -> #(edge_count, True)
              False -> #(edge_count, False)
            }
          }
          True -> {
            case !current_is_rectangle && next_is_rectangle {
              True -> #(edge_count, True)
              False -> #(edge_count+1, False)
            }
          }
        }
      })

      let edge_count = case edge_detected {
        True -> edge_count + 1
        False -> edge_count
      }
      edge_count + vertical_edge(y+compare_orientation, compare_orientation, height, width, rectangle)
    }
  }
}

pub fn horizontal_edge(x: Int, compare_orientation: Int, height: Int, width: Int, rectangle: set.Set(#(Int, Int))) -> Int {
  case x > width+1 || x < 0 {
    True -> 0
    False -> {
      let #(edge_count, edge_detected) = list.range(0, height) |>
      list.fold(#(0, False), fn(acc, y) {
        let #(edge_count, edge_detected) = acc
        let current_is_rectangle = set.contains(rectangle, #(x, y))
        let next_is_rectangle = set.contains(rectangle, #(x+compare_orientation, y))

        case edge_detected {
          False -> {
            case !current_is_rectangle && next_is_rectangle {
              True -> #(edge_count, True)
              False -> #(edge_count, False)
            }
          }
          True -> {
            case !current_is_rectangle && next_is_rectangle {
              True -> #(edge_count, True)
              False -> #(edge_count+1, False)
            }
          }
        }
      })

      let edge_count = case edge_detected {
        True -> edge_count + 1
        False -> edge_count
      }
      edge_count + horizontal_edge(x+compare_orientation, compare_orientation, height, width, rectangle)
    }
  }
}

pub fn part_two(input: glearray.Array(glearray.Array(String)), height: Int, width: Int) {
  let #(_, total) = list.range(1, height) |>
  list.fold([], fn(acc, x) {
    list.range(1, width) |>
    list.fold(acc, fn(acc_inner, y) {[#(x, y), ..acc_inner]})
  }) |>
  list.reverse |>
  list.fold(#(set.new(), 0), fn(acc, coords) {
    let #(x, y) = coords
    let #(all_visited, total) = acc
    case set.contains(all_visited, coords) {
      True -> acc
      False -> {
        let target_plant = index_matrix(input, x, y)
        let #(all_visited, visited) = traverse_part_two(input, x, y, target_plant, all_visited, set.new())
        let vertical_edge_left_to_right = vertical_edge(0, 1, height, width, visited)
        let vertical_edge_right_to_left = vertical_edge(width+1, -1, height, width, visited)
        let horizontal_edge_top_to_bottom = horizontal_edge(0, 1, height, width, visited)
        let horizontal_edge_bottom_to_top = horizontal_edge(height+1, -1, height, width, visited)
        let num_of_edges = vertical_edge_right_to_left + vertical_edge_left_to_right + horizontal_edge_top_to_bottom + horizontal_edge_bottom_to_top
        #(all_visited, total + {set.size(visited) * num_of_edges})
      }
    }
  })

  total |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.split("\n") |>
    list.map(fn(line) {
      "0" <> line <> "0"
    }) |>
    list.map(fn(line) { string.to_graphemes(line)} )

  let height = list.length(input)
  let assert [row, .._rest] = input
  let width = list.length(row) - 2 // because of the padding

  let pad_line = list.range(0, width+1) |>
    list.fold([], fn (acc, _) {
      ["0", ..acc]
    })
  let input = [pad_line, ..input]
  let input = list.append(input, [pad_line])

  let input = glearray.from_list(list.map(input, fn(line) {glearray.from_list(line)}))

  io.print("Part one: ")
  part_one(input, height, width)

  io.print("Part two: ")
  part_two(input, height, width)
}
