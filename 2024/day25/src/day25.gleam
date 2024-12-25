import gleam/int
import gleam/result
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn try_key_lock(key: List(Int), lock: List(Int), max_col_len: Int) -> Bool {
  list.zip(key, lock) |>
  list.map(fn(pair) {
    let #(left, right) = pair
    left + right + 1
  }) |>
  list.all(fn (sum) { sum < max_col_len })
}

fn part_one(keys: List(List(Int)), locks: List(List(Int)), max_col_len: Int) {
  io.print("Part one: ")
  list.fold(keys, 0, fn(acc, key) {
    list.fold(locks, acc, fn(acc, lock) {
      case try_key_lock(key, lock, max_col_len) {
        False -> acc
        True -> acc + 1
      }
    })
  }) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.split("\n\n") |>
    list.map(fn (schem) {
      schem |> string.split("\n") |>
      list.map(fn(line) { string.to_graphemes(line) })
    }) |>
    list.map(fn (schem) {
      list.transpose(schem)
    })

  let assert Ok(schem) = list.first(input)
  let assert Ok(schem) = list.first(schem)
  let col_len = list.length(schem)

  let #(keys, locks) = list.fold(input, #([], []), fn(acc, schem) {
    let #(keys, locks) = acc
    let counts = list.fold(schem, [], fn(acc, line) {
      let count = list.count(line, fn(c) { c == "#"}) - 1
      [count, ..acc]
    })
    let counts = list.reverse(counts)
    let is_lock = list.transpose(schem) |> list.first |> result.unwrap([]) |> list.all(fn (c) { c == "#" })
    case is_lock {
        True ->  {
          let locks = [counts, ..locks]
          #(keys, locks)
        }
        False -> {
          let keys = [counts, ..keys]
          #(keys, locks)
        }
    }
  })

  part_one(keys, locks, col_len)
}
