import gleam/set
import gleam/int
import gleam/dict
import gleam/io
import gleam/list
import trie
import gleam/string
import simplifile

fn get_match_length(patterns: trie.Trie(String, Nil), towel: List(String), lengths: List(Int), take_lenghts: List(Int)) -> List(Int) {
  case take_lenghts {
    [] -> lengths
    [take_len, ..rest] -> {
      let len = list.length(towel)
      case take_len > len {
        True -> lengths
        False -> {
          let part = list.take(towel, take_len)
          case trie.get(patterns, part) {
            Error(_) -> get_match_length(patterns, towel, lengths, rest)
            Ok(_) -> get_match_length(patterns, towel, [take_len, ..lengths], rest)
          }
        }
      }
    }
  }
}

fn count_possible_arrangements_towel(patterns: trie.Trie(String, Nil), towel: List(String), take_lenghts: List(Int),
  memo: dict.Dict(List(String), Int)) -> #(dict.Dict(List(String), Int), Int) {

  case towel {
    [] -> #(memo, 1)
    _ -> {
      let match_lengths = get_match_length(patterns, towel, [], take_lenghts)
      case match_lengths {
        [] -> #(memo, 0)
        _ -> {
          let #(memo, count) = list.fold(match_lengths, #(memo, 0), fn (acc, take_len) {
            let #(memo, current_count) = acc
            let towel = list.drop(towel, take_len)
            case dict.get(memo, towel) {
              Ok(count) -> #(memo, current_count + count)
              Error(_) -> {
                let #(memo, new_count) = count_possible_arrangements_towel(patterns, towel, take_lenghts, memo)
                let memo = dict.insert(memo, towel, new_count)
                #(memo, new_count + current_count)
              }
            }
          })
          let memo = dict.insert(memo, towel, count)
          #(memo, count)
        }
      }
    }
  }
}

fn part_one(patterns: trie.Trie(String, Nil), towels: List(String), take_lenghts: List(Int)) {
  io.print("Part one: ")
  list.map(towels, fn(towel) { count_possible_arrangements_towel(patterns, string.to_graphemes(towel), take_lenghts, dict.new()) }) |>
  list.map(fn(t) { t.1 }) |>
  list.count(fn(count) { count > 0 }) |>
  int.to_string |>
  io.println
}

fn part_two(patterns: trie.Trie(String, Nil), towels: List(String), take_lenghts: List(Int)) {
  io.print("Part two: ")
  list.map(towels, fn(towel) { count_possible_arrangements_towel(patterns, string.to_graphemes(towel), take_lenghts, dict.new()) }) |>
  list.fold(0, fn(acc, is_towel) { acc + is_towel.1 }) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let assert [patterns, towels] = string.split(input, "\n\n")

  let patterns = patterns |>
    string.split(", ") |>
    list.map(fn (pattern) { pattern |> string.to_graphemes }) |>
    list.map(fn (pattern) { #(pattern, Nil) })
  let patterns = trie.from_list(patterns)

  let take_lenghts = trie.to_list(patterns) |>
    list.map(fn(t) {
      let #(part, _) = t
      list.length(part)
    }) |>
    list.fold(set.new(), fn (acc, len) { set.insert(acc, len) })
  let take_lenghts = set.to_list(take_lenghts)

  let towels = string.trim_end(towels) |> string.split("\n")

  part_one(patterns, towels, take_lenghts)
  part_two(patterns, towels, take_lenghts)
}
