defmodule Day6 do
  import Utils
  def part_one() do
    read_from_file("6") |>
    Enum.map(fn line -> line |> String.split(":") end) |>
    Enum.map(fn parts -> parts |> Enum.at(1) end) |>
    Enum.map(fn parts -> parts |> String.trim() end) |>
    Enum.map(fn line -> parse_a_line([], 0, false, String.codepoints(line)) end) |>
    Enum.zip() |>
    Enum.map(fn {time, record} -> all_new_records(0, 1, time, record) end) |>
    Enum.reduce(1, fn records, acc -> acc * records end) |>
    IO.inspect()
  end

  def part_two() do
    one_race = read_from_file("6") |>
    Enum.map(fn line -> line |> String.split(":") end) |>
    Enum.map(fn parts -> parts |> Enum.at(1) end) |>
    Enum.map(fn parts -> parts |> String.trim() end) |>
    Enum.map(fn line -> parse_a_line_part_two(0, String.codepoints(line)) end)

    all_new_records(0, 1, Enum.at(one_race, 0), Enum.at(one_race, 1)) |>
    IO.inspect()
  end

  def all_new_records(acc, curr, time, record) when curr == time do acc end
  def all_new_records(acc, curr, time, record) do
    distance = curr * (time-curr)
    if distance > record do
      all_new_records(acc + 1, curr+1, time, record)
    else
      all_new_records(acc, curr+1, time, record)
    end
  end

  def parse_a_line_part_two(number, []) do number end
  def parse_a_line_part_two(number, [head | tail]) do
    if head >= "0" and head <= "9" do
      parse_a_line_part_two(number*10 + String.to_integer(head), tail)
    else
        parse_a_line_part_two(number, tail)
    end
  end

  def parse_a_line(acc, number, flag, []) do if flag do acc ++ [number] else acc end end
  def parse_a_line(acc, number, flag, [head | tail]) do
    if head >= "0" and head <= "9" do
      parse_a_line(acc, number*10 + String.to_integer(head), true, tail)
    else
      if flag do
        parse_a_line(acc ++ [number], 0, false, tail)
      else
        parse_a_line(acc, 0, false, tail)
      end
    end
  end
end
