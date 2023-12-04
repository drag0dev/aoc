defmodule Day4 do
  import Utils

  def main() do
    read_from_file("4") |>
    Enum.map(fn line -> line |> String.replace(~r/Card[\ ]*[0-9]*:[\ ]*/, "") end) |>
    Enum.map(fn line -> line |> String.split("|") end) |>
    Enum.map(fn [winning_numbers, my_numbers] ->
      {
        parse_all_numbers([], 0, String.codepoints(winning_numbers)),
        parse_all_numbers([], 0, String.codepoints(my_numbers)),
      }
    end) |>
    Enum.map(fn {winning_numbers, my_numbers} ->
      power = Enum.filter(winning_numbers, fn x -> Enum.member?(my_numbers, x) end) |> length()
      if power == 0 do
        {0, 0}
      else
        {2 ** (power-1), power}
      end
    end) |>

    # PART ONE
    # Enum.reduce(0, fn {val, _}, acc -> acc + val end) |>

    # PART TWO
    Enum.with_index() |>
    Enum.reduce(%{}, fn {{res, power}, index}, multipliers ->
      multi = Map.get(multipliers, index, 1)
      multipliers = Map.put_new(multipliers, index, 1)
      update_multipliers(multipliers, index, power, multi)
    end) |>
    Enum.reduce(0, fn {key, val}, acc -> acc + val end) |>

    IO.puts()
  end

  def parse_all_numbers(acc, num, []) do if num > 0 do acc ++ [num] else acc end end
  def parse_all_numbers(acc, num, [head | tail]) do
    if head >= "0" and head <= "9" do
      parse_all_numbers(acc, num*10 + String.to_integer(head), tail)
    else
      if num > 0 do
        parse_all_numbers(acc ++ [num], 0, tail)
      else
        parse_all_numbers(acc, 0, tail)
      end
    end
  end

  def update_multipliers(multipliers, index, power, multi) when power == 0 do multipliers end
  def update_multipliers(multipliers, index, power, multi) when power == 1 do
    update_helper(multipliers, index, power, multi)
  end
  def update_multipliers(multipliers, index, power, multi) when power > 0 do
    update_multipliers(multipliers, index, power-1, multi) |>
    update_helper(index, power, multi)
  end

  def update_helper(multipliers, index, power, multi) do
    multipliers |>
    Map.get_and_update(index+power, fn current ->
      if current == nil do
        {current, 1+multi}
      else
        {current, current + multi}
      end
    end) |> elem(1)
  end
end
