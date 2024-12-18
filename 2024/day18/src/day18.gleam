import gleam/set
import gleam/io
import gleam/list
import gleam/int
import gleam/string
import simplifile
import gleam/deque

fn bfs(visited: set.Set(#(Int, Int)), q: deque.Deque(#(Int, Int, Int)), dimension: Int) -> Int {
  let len = deque.length(q)
  case len == 0 {
    True -> -1
    False -> {
      let #(visited, q, steps) = list.range(0, len-1) |>
      list.fold_until(#(visited, q, -1), fn(acc, _) {
        let #(visited, q, _) = acc

        let assert Ok(#(#(x, y, steps), q)) = deque.pop_front(q)

        case x == dimension && y == dimension {
          True -> list.Stop(#(visited, q, steps))
          False -> {
            let #(q, visited) = [#(0, 1), #(0, -1), #(1, 0), #(-1, 0)] |>
            list.fold(#(q, visited), fn(acc, direction_change) {
              let #(inner_q, inner_visited) = acc
              let x = x + direction_change.0
              let y = y + direction_change.1
              case x > -1 && x <= dimension && y > -1 && y <= dimension && !set.contains(visited, #(x, y)) {
                False -> #(inner_q, inner_visited)
                True -> #(deque.push_back(inner_q, #(x, y, steps+1)), set.insert(inner_visited, #(x, y)))
              }
            })
            list.Continue(#(visited, q, -1))
          }
        }

      })
      case steps != -1 {
        True -> steps
        False -> bfs(visited, q, dimension)
      }
    }
  }
}

fn part_one(input: set.Set(#(Int, Int))) {
  io.print("Part one: ")
  let q = deque.from_list([#(0, 0, 0)])
  bfs(input, q, 70) |>
  int.to_string |>
  io.println
}

fn part_two(input: List(#(Int, Int))) {
  io.print("Part two: ")
  let #(_, byte) = list.fold_until(input, #(set.new(), #(-1, -1)), fn(acc, byte) {
    let #(visited, byte_found) = acc
    let visited = set.insert(visited, byte)
    case bfs(visited, deque.from_list([#(0, 0, 0)]), 70) {
      -1 -> list.Stop(#(visited, byte))
      _ -> list.Continue(#(visited, byte_found))
    }
  })
  { int.to_string(byte.0) <> "," <> int.to_string(byte.1) } |>
  io.println
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input")
  let input = string.trim_end(input) |>
    string.trim_end |>
    string.split("\n") |>
    list.map(fn(line) {
      let assert [x, y] = line |>
      string.split(",") |>
      list.map(fn(num) {
       let assert Ok(num) = int.parse(num)
       num
      })
      #(x, y)
    })

  let part_one_input = list.take(input, 1024) |> set.from_list
  part_one(part_one_input)
  part_two(input)
}
