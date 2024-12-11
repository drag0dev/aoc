import gleam/dict
import gleam/io
import gleam/result
import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn list_to_int(digits: List(Int), acc: Int) -> Int {
  case digits {
    [first, ..rest] -> {
      let acc = acc * 10
      let acc = acc + first
      list_to_int(rest, acc)
    }
    [] -> acc
  }
}

pub fn split_number(digits: List(Int), number_of_digits: Int) -> #(Int, Int) {
  let #(left, right) = list.split(digits, number_of_digits/2)
  #(list_to_int(left, 0), list_to_int(right, 0))
}

pub fn blink(input: List(Int)) -> List(Int) {
  case input {
    [first, ..rest] -> {
      case first == 0 {
        True -> [1, ..blink(rest)]
        False -> {
          let digits = case int.digits(first, 10) {
            Ok(digits) -> digits
            Error(_) -> panic as "unreachable"
          }
          let number_of_digits = list.length(digits)

          case number_of_digits % 2 == 0 {
            True -> {
              let #(left, right) = split_number(digits, number_of_digits)
              [left, right, ..blink(rest)]
            }
            False -> [first*2024, ..blink(rest)]
          }
        }
      }
    }
    [] -> []
  }
}

// key: #(num, blinks_left) value: len
pub fn blink_n_times(input: List(Int), n: Int, dp: dict.Dict(#(Int, Int), Int)) -> #(dict.Dict(#(Int, Int), Int), Int) {
  case n == 0 {
    True -> #(dp, list.length(input))
    False -> {
      let input = blink(input)
      let #(dp, len) = list.fold(input, #(dp, 0), fn(t, num) {
        case dict.get(dp, #(num, n-1)) {
          Ok(times) -> #(t.0, t.1+times)
          Error(_) -> {
            let #(dp_inner, len_inner) = blink_n_times([num], n-1, t.0)
            let dp_inner = dict.insert(dp_inner, #(num, n-1), len_inner)
            #(dp_inner, t.1+len_inner)
          }
        }
      })
      #(dp, len)
    }
  }
}

pub fn part_one(input: List(Int)) {
  let #(_, len) = blink_n_times(input, 25, dict.new())
  int.to_string(len) |>
  io.println
}

pub fn part_two(input: List(Int)) {
  let #(_, len) = blink_n_times(input, 75, dict.new())
  int.to_string(len) |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.split(" ") |>
    list.map(fn(num) { int.parse(num) |> result.unwrap(-1) })

  io.print("Part one: ")
  part_one(input)

  io.print("Part two: ")
  part_two(input)
}
