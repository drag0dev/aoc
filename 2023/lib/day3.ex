defmodule Day3 do
  import Utils

  @len 140

  # PART ONE
  ##########################################################################
  def part_one() do
    [String.duplicate(".", @len)] ++ read_from_file("3") ++ [String.duplicate(".", @len)] |>
    Enum.map(fn line -> line |> String.codepoints end) |>
    Enum.chunk_every(3, 1, :discard) |>
    Enum.map(fn [top, mid, bot] ->
      Enum.with_index(mid) |>
      Enum.reduce([0, 0, false], fn {char, idx}, [sum, curr, flag] ->
        if char >= "0" and char <= "9" do
          [sum, curr*10 + String.to_integer(char), flag || is_symbol_present(top, mid, bot, idx)]
        else
          if curr > 0 and flag == true do
            [sum + curr, 0, false]
          else
            [sum, 0, false]
          end
        end
      end)
    end) |>
    Enum.map(fn [sum, curr, flag] ->
      if flag == true do
        sum + curr
      else
        sum
      end
    end) |>
    Enum.reduce(fn acc, el -> acc + el end) |>
    IO.puts()
  end

  def is_symbol_present(top, mid, bot, idx) do
    [
      is_symbol(top, idx),
      is_symbol(top, idx-1),
      is_symbol(top, idx+1),
      is_symbol(mid, idx+1),
      is_symbol(mid, idx-1),
      is_symbol(bot, idx),
      is_symbol(bot, idx+1),
      is_symbol(bot, idx-1),
    ] |>
    Enum.any?()
  end

  def is_symbol(line, idx) do
    if idx < 0 or idx >= @len do
      false
    else
      char = Enum.at(line, idx)
      if (char >= "0" and char <= "9") or char == "." do
        false
      else
        true
      end
    end
  end

  # PART TWO
  ##########################################################################
  def part_two() do
    [String.duplicate(".", @len)] ++ read_from_file("3") ++ [String.duplicate(".", @len)] |>
    Enum.map(fn line -> line |> String.codepoints end) |>
    Enum.chunk_every(3, 1, :discard) |>
    Enum.with_index() |>
    Enum.map(fn {[top, mid, bot], row} ->
      Enum.with_index(mid) |>
      Enum.reduce([%{}, 0, []], fn {char, idx}, [map, curr, asterix] ->
        if char >= "0" and char <= "9" do
          [map, curr*10 + String.to_integer(char), asterix ++ is_symbol_asterix(top, mid, bot, idx, row)]
        else
          update_accumulator_part_two(map, curr, asterix)
        end
      end)
    end) |>
    Enum.map(fn [map, curr, asterix] -> update_accumulator_part_two(map, curr, asterix) end) |>
    Enum.reduce(%{}, fn [map, _, _], acc -> Map.merge(acc, map, fn _, left, right -> left ++ right end) end) |>
    Enum.reduce(0, fn {_, nums}, acc ->
      if length(nums) == 2 do
        acc + Enum.at(nums, 0) * Enum.at(nums, 1)
      else
        acc
      end
    end) |>
    IO.puts()
  end

  # if we have a number and it is adjecant to at least one asterix we update our map
  # updating map means appending the current number to that asterix key
  def update_accumulator_part_two(map, curr, asterix) do
    if curr > 0 and length(asterix) > 0 do
      {_, new_map} =
        asterix |>
        Enum.uniq() |>
        Enum.reduce(map, fn [x, y], acc ->
          Map.get_and_update(acc, {x, y}, fn prev_val ->
            if prev_val == nil do
              {prev_val, [curr]}
            else
              {prev_val, [curr] ++ prev_val}
            end
          end)
        end)
      [new_map, 0, []]
    else
      [map, 0, []]
    end
  end

  def is_symbol_asterix(top, mid, bot, idx, row) do
    [
      [row-1, check_asterix(top, idx)],
      [row-1, check_asterix(top, idx-1)],
      [row-1, check_asterix(top, idx+1)],
      [row, check_asterix(mid, idx+1)],
      [row, check_asterix(mid, idx-1)],
      [row+1, check_asterix(bot, idx)],
      [row+1, check_asterix(bot, idx+1)],
      [row+1, check_asterix(bot, idx-1)],
    ] |>
    Enum.filter(fn [x, y] -> y != -1 end)
  end

  def check_asterix(line, idx) do
    if idx >= 0 and idx < @len and Enum.at(line, idx) == "*" do
      idx
    else
      -1
    end
  end
end
