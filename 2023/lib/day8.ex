defmodule Day8 do
  import Utils

  def part_one() do
    [moves, mappings] =
      File.read!("./inputs/8.txt") |>
      String.trim() |>
      String.split("\n\n")

    moves = moves |>
    String.codepoints() |>
    Enum.map(fn letter -> if letter == "R" do 1 else 0 end end)
    moves_len = length(moves)

    mappings = mappings |>
    String.split("\n") |>
    Enum.map(fn line -> parse_mapping(line) end) |>
    Enum.reduce(%{}, fn {key, left, right}, acc -> Map.put(acc, key, [left, right]) end)


    # PART ONE
    # first_key = "AAA"
    # part_one_res = find_zzz(first_key, 0, mappings, moves_len, moves)
    # IO.puts("PART ONE: #{part_one_res}")

    # PART TWO
    starting_keys = mappings |> Map.keys() |> Enum.filter(fn x -> x |> String.ends_with?("A") end)
    [first | tail] = starting_keys |> Enum.map(fn key -> find_zzz(key, 0, mappings, moves_len, moves) end)
    lcm(first, tail) |> trunc() |> IO.inspect()
  end

  def lcm(acc, []) do acc end
  def lcm(acc, [head | tail]) do
    ((head * acc) / gcd(head, acc)) |>
    lcm(tail)
  end

  def gcd(a, b) when b == 0 do a end
  def gcd(a, b) do gcd(b, float_mod(a, b)) end

  def float_mod(a, b) do
    a- trunc(a/b) * b
  end

  def find_zzz(curr_key, curr_index, mappings, moves_len, moves) do
    index = rem(curr_index, moves_len)
    move = Enum.at(moves, index)
    next_key = mappings |> Map.get(curr_key) |> Enum.at(move)

    # PART ONE
    # if next_key == "ZZZ" do
    #   curr_index+1

    # PART TWO
    if String.ends_with?(next_key, "Z") do
      curr_index+1
    else
      find_zzz(next_key, curr_index+1, mappings, moves_len, moves)
    end
  end

  def parse_mapping(str) do
    [key, values] = String.split(str, " = ")

    [left, right] = values |>
    String.replace("(", "") |>
    String.replace(")", "") |>
    String.replace(" ", "") |>
    String.split(",")

    {key, left, right}
  end
end
