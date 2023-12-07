defmodule Day7 do
  import Utils

  @letter_strength %{
    "J" => 0,
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "T" => 9,
    # "J" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
  }

  @hand_types [:five_kind, :four_kind, :full_house, :three_kind, :two_pair, :one_pair, :high_card]

  def main() do
    mapped_hands = read_from_file("7") |>
    Enum.map(fn line -> line |> String.split(" ") end) |>
    Enum.map(fn [card, num] -> {card, String.to_integer(num)} end) |>
    Enum.reduce(%{}, fn {card, num}, acc ->
      {_, new_map } = Map.get_and_update(acc, check_type(%{}, String.codepoints(card)), fn prev ->
        if prev == nil do
          {prev, [{card, num}]}
        else
          {prev, prev ++ [{card, num}]}
        end
      end)
      new_map
    end)

    @hand_types |>
    Enum.reverse() |>
    Enum.reduce([], fn hand_type, acc ->
      hands = Map.get(mapped_hands, hand_type)
      if hands != nil do
        sorted_hands = hands |> Enum.sort_by(fn el -> el end, fn {a, _}, {b, _} -> compare(a, b) end)
        acc ++ sorted_hands
      else
        acc
      end
    end) |>
    Enum.with_index() |>
    Enum.reduce(0, fn {{_, num}, index}, acc ->
      acc + (index + 1) * num
    end) |>
    IO.inspect()
  end

  def compare(a, b) do
    a_list = String.codepoints(a)
    b_list = String.codepoints(b)
    a_list = Enum.map(a_list, fn letter -> Map.get(@letter_strength, letter) end)
    b_list = Enum.map(b_list, fn letter -> Map.get(@letter_strength, letter) end)
    a_list < b_list
  end

  def check_type(acc, []) do
    # PART TWO
    acc = apply_joker(acc)

    len = Map.keys(acc) |> length()
    case len do
      1 -> :five_kind
      2 ->
        is_full_house = Map.values(acc) |> Enum.find(fn x -> x == 2 end)
        if is_full_house do
          :full_house
        else
          :four_kind
        end
      3 ->
        two_pair_count = Map.values(acc) |> Enum.count(fn x -> x == 2 end)
        if two_pair_count == 2 do
          :two_pair
        else
          :three_kind
        end
      4 -> :one_pair
      5 -> :high_card
    end
  end

  def apply_joker(acc) do
    joker_count = Map.get(acc, "J")
    if joker_count == nil or joker_count == 5 do
      acc
    else
      cleared_map = Map.delete(acc, "J")
      {max_freq_key, _} =
        cleared_map |>
        Map.keys() |>
        Enum.map(fn key -> {key, Map.get(cleared_map, key)} end) |>
        Enum.max_by(fn {_, val} -> val end)
      Map.update!(cleared_map, max_freq_key, fn val -> val + joker_count end)
    end
  end

  def check_type(acc, [head | tail]) do
    {_, new_map } = Map.get_and_update(acc, head, fn prev ->
      if prev == nil do
        {prev, 1}
      else
        {prev, prev+1}
      end
    end)
    check_type(new_map, tail)
  end
end
