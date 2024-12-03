defmodule Day11 do
  import Utils

  def main() do
    matrix = read_from_file("11") |> Enum.map(fn line -> String.codepoints(line) end)
    height = length(matrix)
    width = length(Enum.at(matrix, 0))

    empty_rows = get_empty_rows([], 0, matrix)

    temp = Enum.to_list(1..width) |> Enum.map(fn _ -> false end)
    empty_cols = get_empty_cols(temp, 0, height, width, matrix)

    all_galaxies = get_all_galaxies([], 0, height, width, matrix)
    all_galaxies |>
    Enum.map(fn {x, y} ->
      Enum.map(all_galaxies, fn {x1, y1} -> calcualate_path({x, y}, {x1, y1}, empty_cols, empty_rows) end) |>
      Enum.sort(fn a, b -> a > b end) |>
      Enum.at(1)
    end) |>
    # Enum.reduce(0, fn x, acc -> x + acc end) |>
    IO.inspect()
  end

  def calcualate_path({first_x, first_y}, {second_x, second_y}, empty_cols, empty_rows) do
    distance = abs(first_x - second_x) + abs(first_y - second_y)
    extra_cols = Enum.reduce(empty_cols, 0, fn x, acc ->
      if x <= second_y and x >= first_y or x >= second_y and x <= first_y do
        acc + 1
      else
        acc
      end
    end)

    extra_rows = Enum.reduce(empty_rows, 0, fn x, acc ->
      if x <= second_x and x >= first_x or x >= second_x and x <= first_x do
        acc + 1
      else
        acc
      end
    end)

    distance + extra_rows + extra_cols
  end

  def get_all_galaxies(acc, index, height, width, matrix) when index == height*width do acc end
  def get_all_galaxies(acc, index, height, width, matrix) do
    x = div(index, width)
    y = rem(index, width)
    curr = Enum.at(matrix, x) |> Enum.at(y)
    if curr == "#" do
      get_all_galaxies(acc ++ [{x, y}], index+1, height, width, matrix)
    else
      get_all_galaxies(acc, index+1, height, width, matrix)
    end
  end

  def get_empty_rows(acc, index, []) do acc end
  def get_empty_rows(acc, index, [head | tail]) do
    all_dots = Enum.all?(head, fn x -> x == "." end)
    if all_dots do
      get_empty_rows(acc ++ [index], index+1, tail)
    else
      get_empty_rows(acc, index+1, tail)
    end
  end

  def get_empty_cols(acc, index, height, width, matrix) when index == width do
    acc |>
    Enum.with_index() |>
    Enum.filter(fn {a, _} -> a == false end) |>
    Enum.map(fn {a, idx} -> idx end)
  end
  def get_empty_cols(acc, index, height, width, matrix) do
    is_not_empty = matrix |>
    Enum.map(fn line -> Enum.at(line, index) != "." end) |>
    Enum.any?()
    List.replace_at(acc, index, is_not_empty) |>
    get_empty_cols(index+1, height, width, matrix)
  end
end
