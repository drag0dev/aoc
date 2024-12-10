import glearray
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn add_n_times(l: List(Int), what: Int, times: Int) -> List(Int) {
  case times == 0 {
    True -> l
    False -> add_n_times([what, ..l], what, times-1)
  }
}

fn build_input_line(input: List(Int), l: List(Int), idx: Int, id: Int) -> List(Int) {
  case input {
    [times, ..rest] -> {
      case idx % 2 == 0 {
        True -> {
          let l = add_n_times(l, id, times)
          build_input_line(rest, l, idx+1, id+1)
        }
        False -> {
          let l = add_n_times(l, -1, times)
          build_input_line(rest, l, idx+1, id)
        }
      }
    }
    [] -> l
  }
}

fn index_array(input: glearray.Array(a), idx: Int) -> a {
  case glearray.get(input, idx) {
    Ok(num) -> num
    Error(_) -> panic as "unreachable"
  }
}

// #(num, idx)
fn first_num_reverse(line_arr: glearray.Array(Int), idx: Int) -> #(Int, Int) {
  case index_array(line_arr, idx) {
    -1 -> first_num_reverse(line_arr, idx-1)
    num -> #(num, idx-1)
  }
}

fn build_line(res: List(Int), line: List(Int), line_arr: glearray.Array(Int), idx: Int, reverse_idx: Int) -> List(Int) {
  case idx <= reverse_idx {
    False -> res
    True -> {
      case line {
        [first, ..rest] -> {
          case first == -1 {
            False -> build_line([first, ..res], rest, line_arr, idx+1, reverse_idx)
            True -> {
              let #(num, new_reverse_idx) = first_num_reverse(line_arr, reverse_idx)
              // +1 because the function returns the new reverse_idx, not where the number was found
              case new_reverse_idx+1 > idx {
                True -> build_line([num, ..res], rest, line_arr, idx+1, new_reverse_idx)
                False -> build_line(res, rest, line_arr, idx+1, new_reverse_idx)
              }
            }
          }
        }
        [] -> res
      }
    }
  }
}

fn part_one(input: List(Int)) {
  let reverse_line = build_input_line(input, [], 0, 0)
  let line = list.reverse(reverse_line)
  let line_arr = glearray.from_list(line)
  let len = glearray.length(line_arr)

  build_line([], line, line_arr, 0, len-1) |>
  list.reverse |>
  list.index_fold(0, fn(acc, num, idx) {
    case num {
      -1 -> acc
      _ -> acc + {num*idx}
    }
  }) |>
  int.to_string |>
  io.println
}

fn find_match(spaces: List(#(Int, Int, Int)), block_size: Int, block_idx: Int) -> #(Int, Int, Int) {
  case spaces {
    [first, ..rest] -> {
      case first.1 >= block_idx {
        True -> #(-1, -1, -1)
        False -> {
          case first.0 >= block_size {
            True -> first
            False -> find_match(rest, block_size, block_idx)
          }
        }
      }
    }
    [] -> #(-1, -1, -1)
  }
}

fn shift_index_by_n(l: List(#(Int, Int, Int)), n: Int, after_idx: Int) -> List(#(Int, Int, Int)) {
  list.map(l, fn(t){
    case t.1 > after_idx {
      True -> #(t.0, t.1+n, t.2)
      False -> t
    }
  })
}

fn apply_shift(block: #(Int, Int, Int), indices: List(Int)) -> #(Int, Int, Int) {
  case indices {
    [first, ..rest] -> {
      case first < block.1 {
        True -> {
          let block = #(block.0, block.1+1, block.2)
          apply_shift(block, rest)
        }
        False -> apply_shift(block, rest)
      }
    }
    [] -> block
  }
}

fn match_blocks(spaces: List(#(Int, Int, Int)), blocks: List(#(Int, Int, Int)), used_up_blocks: List(#(Int, Int, Int))) -> #(List(#(Int, Int, Int)), List(#(Int, Int, Int)), List(#(Int, Int, Int))) {
  case blocks {
    [block, ..rest] -> {
      let matched_space = find_match(spaces, block.0, block.1)
      case matched_space == #(-1, -1, -1) || matched_space.1 > block.1 {
        True -> {
          match_blocks(spaces, rest, [block, ..used_up_blocks])
        }
        False -> {
          let moved_block = #(block.0, matched_space.1, block.2)
          let block_to_space = #(block.0, block.1, 0)

          let remaining_space = matched_space.0 - block.0
          let spaces = list.filter(spaces, fn(space) {matched_space != space})

          // insert new space if needed
          let #(block_to_space, used_up_blocks, spaces,rest) = case remaining_space == 0 {
            True -> #(block_to_space, used_up_blocks, spaces, rest)
            False -> {
              // when inserting a new space, all blocks, spaces, used_up_blocks, and
              // block_to_space have to me shifted by one to the right
              let rest = shift_index_by_n(rest, 1, matched_space.1)
              let spaces = shift_index_by_n(spaces, 1, matched_space.1)
              let used_up_blocks = shift_index_by_n(used_up_blocks, 1, matched_space.1)
              let block_to_space = #(block_to_space.0, block_to_space.1+1, block_to_space.2)

              let new_space = #(remaining_space, matched_space.1 + 1, 0)
              let spaces = list.sort([new_space, ..spaces], fn(left, right){ int.compare(left.1, right.1) })
              #(block_to_space, used_up_blocks, spaces, rest)
            }
          }

          match_blocks(spaces, rest, [block_to_space, moved_block, ..used_up_blocks])
        }
      }
    }
    [] -> #(spaces, blocks, used_up_blocks)
  }
}

pub fn part_two(input: List(Int)) {
  let input_idx = list.index_map(input, fn(num, idx) { #(num, idx, 0) })
  let input_idx = list.filter(input_idx, fn(t) {t.0 > 0})
  let #(spaces, blocks) = list.partition(input_idx, fn(t) {t.1 % 2 != 0})
  let blocks = list.map(blocks, fn(pair) {#(pair.0, pair.1, pair.1/2)})
  let blocks = list.reverse(blocks)

  let #(spaces, blocks, used_up_blocks) = match_blocks(spaces, blocks, [])
  list.append(spaces, blocks) |>
  list.append(used_up_blocks) |>
  list.sort(fn (left, right) {int.compare(left.1, right.1)}) |>
  list.fold([], fn(acc, t) {
    list.range(0, t.0-1) |>
    list.fold(acc, fn(acc_inner, _) { [t.2, ..acc_inner] })
  }) |>
  list.reverse |>
  list.index_fold(0, fn(acc, num, index) { acc + {num*index} }) |>
  int.to_string |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.to_graphemes |>
    list.map(fn(num) {
      let assert Ok(num) = int.parse(num)
      num
    })

    io.print("Part one: ")
    part_one(input)
    io.print("Part two: ")
    part_two(input)
}
