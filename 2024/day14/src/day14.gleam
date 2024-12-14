import gleam/bit_array
import gleam/set
import gleam/dict
import gleam/int
import gleam/list
import gleam/io
import gleam/string
import simplifile
import pngleam

const board_width = 101
const board_height = 103

fn generate_image(robots: List(List(Int)), idx: Int) {
  let file_name = "states/" <> int.to_string(idx) <> ".png"
  let robot_coords = list.fold(robots, set.new(), fn (acc, robot) {
    let assert [x, y, _, _] = robot
    set.insert(acc, #(x, y))
  })

  list.range(0, board_height-1) |>
  list.fold([], fn (acc, y) {
    let line = list.range(0, board_width-1) |>
      list.fold(<<>>, fn (inner_acc, x) {
        let bit = case set.contains(robot_coords, #(x, y)) {
            False -> << 0x00, 0x00, 0x00 >>
            True -> << 0xFF, 0xFF, 0xFF >>
          }
        bit_array.append(inner_acc, bit)
      })
    [line, ..acc]
  }) |>
  list.reverse |>
  pngleam.from_packed(
  width: board_width,
  height: board_height,
  color_info: pngleam.rgb_8bit,
  compression_level: pngleam.no_compression
  ) |>
  simplifile.write_bits(file_name, _)
}

fn move_robot(robot: List(Int), move_by: Int) -> List(Int) {
  let assert [x, y, x_change, y_change] = robot
  let x = { { { x + x_change * move_by } % { board_width } } + { board_width } } % { board_width  }
  let y = { { { y + y_change * move_by } % { board_height } } + { board_height } } % { board_height  }
  [x, y, x_change, y_change]
}

fn robot_to_qudrant(robot: List(Int)) -> Int {
  let assert [x, y, _, _] = robot
  let x_middle = {board_width-1}/2
  let y_middle = {board_height-1}/2
  case x == x_middle || y == y_middle {
    True -> -1
    False -> {
      case x < x_middle {
        True -> {
          case y < y_middle {
            True -> 1
            False -> 2
          }
        }
        False -> {
          case y < y_middle {
            True -> 3
            False -> 4
          }
        }
      }
    }
  }
}

fn safety_score(quadrants: dict.Dict(Int, Int)) -> Int {
  dict.keys(quadrants) |>
  list.fold(1, fn (acc, quadrant) {
    case quadrant == -1 {
      True -> acc
      False -> {
        case dict.get(quadrants, quadrant) {
          Ok(count) -> acc * count
          Error(_) -> panic as "unreachable"
        }
      }
    }
  })
}

fn part_one(input: List(List(Int))) {
  io.print("Part one: ")
  let quadrants = list.map(input, fn (robot) { move_robot(robot, 100) }) |>
    list.map(fn (robot) {robot_to_qudrant(robot) }) |>
    list.fold(dict.new(), fn (d, quadrant) {
      case dict.get(d, quadrant) {
        Ok(count) -> dict.insert(d, quadrant, count+1)
        Error(_) -> dict.insert(d, quadrant, 1)
      }
    })

  safety_score(quadrants) |>
  int.to_string |>
  io.println
}

fn part_two(input: List(List(Int))) {
  list.range(0, 35000) |>
  list.fold(input, fn(robots, idx) {
    let robots = list.map(robots, fn (robot) { move_robot(robot, 1) })
    let _ = generate_image(robots, idx+1)
    robots
  })
  io.println("Part two: generated 40k images")
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.replace("p=", "") |>
    string.replace(" v=", ",") |>
    string.split("\n") |>
    list.map(fn (line) {
      line |>
      string.split(",") |>
      list.map(fn (num) {
        let assert Ok(num) = int.parse(num)
        num
      })
    })

  part_one(input)
  part_two(input)
}
