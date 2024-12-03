defmodule Day15 do
  import Utils
  def main() do
    File.read!("./inputs/#{15}.txt") |>
    String.trim |>
    String.split(",") |>
    Enum.map(fn line -> String.to_charlist(line) end) |>
    Enum.map(fn line -> hash(0, line) end) |>
    Enum.reduce(0, fn x, acc -> x + acc end) |>
    IO.inspect()
  end

  def hash(acc, []) do acc end
  def hash(acc, [head | tail]) do
    acc = acc + head
    acc = acc * 17
    acc = rem(acc, 256)
    hash(acc, tail)
  end

end
