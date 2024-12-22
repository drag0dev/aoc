import gleam/set
import gleam/dict
import glearray
import gleam/io
import gleam/int
import gleam/list
import gleam/string
import simplifile

fn simulate_number(num: Int, steps_left: Int) -> Int {
  case steps_left {
    0 -> num
    steps_left -> {
      let num = int.bitwise_exclusive_or(num, num*64) % 16777216
      let num = int.bitwise_exclusive_or(num, num/32) % 16777216
      let num = int.bitwise_exclusive_or(num, num*2048) % 16777216
      simulate_number(num, steps_left-1)
    }
  }
}

fn part_one(nums) {
  io.print("Part one: ")
  list.map(nums, fn(num) { simulate_number(num, 2000) }) |>
  list.fold(0, fn(acc, num) { acc + num}) |>
  int.to_string |>
  io.println
}

fn get_last_digit(num: Int) -> Int {
  case int.digits(num, 10) {
    Error(_) -> panic as "unreachable"
    Ok(digits) -> {
        let assert Ok(digit) = list.last(digits)
        digit
      }
    }
}

fn get_prices(num: Int, steps_left: Int, acc: List(Int)) -> List(Int) {
  case steps_left {
    0 -> list.reverse(acc)
    steps_left -> {
      let num = int.bitwise_exclusive_or(num, num*64) % 16777216
      let num = int.bitwise_exclusive_or(num, num/32) % 16777216
      let num = int.bitwise_exclusive_or(num, num*2048) % 16777216
      let acc = [get_last_digit(num), ..acc]
      get_prices(num, steps_left-1, acc)
    }
  }
}

fn get_diffs(prices: List(Int)) -> List(Int) {
  list.window_by_2(prices) |>
  list.fold([], fn(acc, pair) {
    let #(left, right) = pair
    let diff = right - left
    [diff, ..acc]
  }) |>
  list.reverse
}

fn get_all_seq_prices(diffs: List(Int), prices: glearray.Array(Int)) -> dict.Dict(List(Int), Int) {
  list.window(diffs, 4) |>
  list.index_map(fn (w, i) { #(i, w) }) |>
  list.fold(dict.new(), fn(acc, seq) {
    let #(idx, w) = seq
    let assert Ok(price) = glearray.get(prices, idx+4)
    case dict.get(acc, w) {
      Ok(_) -> acc
      Error(_) -> dict.insert(acc, w, price)
    }
  })
}

fn get_all_possible_seqs(diffs: List(List(Int)), acc: set.Set(List(Int))) -> set.Set(List(Int)) {
  case diffs {
    [] -> acc
    [first, ..rest] -> {
      let seqs = list.window(first, 4) |> set.from_list
      let acc = set.union(acc, seqs)
      get_all_possible_seqs(rest, acc)
    }
  }
}

fn get_price_for_seller_with_seq(seq_price: dict.Dict(List(Int), Int), seq: List(Int)) -> Int {
  case dict.get(seq_price, seq) {
    Ok(price) -> price
    Error(_) -> 0
  }
}

fn part_two(nums) {
  io.print("Part two: ")
  let prices = list.map(nums, fn(num) { get_prices(num, 2000, [get_last_digit(num)]) })
  let diffs = list.map(prices, fn(prices) { get_diffs(prices) })
  let prices = list.map(prices, fn(prices) {glearray.from_list(prices)})
  let seq_prices = list.zip(diffs, prices) |>
    list.map(fn (pair) {
      let #(diffs, prices) = pair
      get_all_seq_prices(diffs, prices)
    })

  get_all_possible_seqs(diffs, set.new()) |>
  set.to_list |>
  list.fold(-99999999999999999999999999, fn(acc, seq) {
    list.fold(seq_prices, 0, fn(acc, seq_prices) {
      let price = get_price_for_seller_with_seq(seq_prices, seq)
      acc + price
    }) |>
    int.max (acc)
  }) |>
  int.to_string |>
  io.println

}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input)
  let nums = string.split(input, "\n") |>
    list.map(fn (num) {
      let assert Ok(num) = int.parse(num)
      num
    })

  part_one(nums)
  part_two(nums)
}
