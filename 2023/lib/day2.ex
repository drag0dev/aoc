defmodule Day2 do
  import Utils
  @red 12
  @green 13
  @blue 14

  def main() do
    read_from_file("2") |>
    Enum.map(fn line ->
      [game, sets] = String.split(line, ":")
      game_idx = game |> String.split() |> Enum.at(1) |> String.codepoints |> parse_num
      acc = count(sets)

      # part one
      # if Map.get(acc, :red) <= @red and Map.get(acc, :green) <= @green and Map.get(acc, :blue) <= @blue do
      #   game_idx
      # else 0 end

      # part two
      Map.get(acc, :red) * Map.get(acc, :green) * Map.get(acc, :blue)
    end) |>
    Enum.reduce(fn acc, el -> acc + el end) |>
    IO.puts()
  end

  def count(line) do
    acc = %{red: 0, green: 0, blue: 0}
    line |>
    String.trim |>
    String.replace(";", ",") |>
    String.split(",") |>
    Enum.map(fn num -> num |> String.trim end) |>
    Enum.reduce(acc, fn num, acc ->
      [num, color] = String.split(num)
      num = parse_num(0, String.codepoints(num))
      case color do
        "red" -> Map.update!(acc, :red, fn x -> max(x, num) end)
        "green" -> Map.update!(acc, :green, fn x -> max(x, num) end)
        "blue" -> Map.update!(acc, :blue, fn x -> max(x, num) end)
        _ -> IO.puts("error")
      end
    end)
  end


  def parse_num(num \\ 0, list)
  def parse_num(num, []) do num end
  def parse_num(num, [head | tail]) do parse_num(num * 10 + String.to_integer(head), tail) end
end
