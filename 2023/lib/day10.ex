defmodule Day10 do
  import Utils
  import Queue

  def main() do
    matrix = read_from_file("10") |>
    Enum.map(fn line -> String.codepoints(line) end)
    {start_row, start_col} = find_start(0, matrix)

    res = [
      loop_len(0, start_row+1, start_col, :down, matrix),
      loop_len(0, start_row-1, start_col, :up, matrix),
      loop_len(0, start_row, start_col+1, :right, matrix),
      loop_len(0, start_row, start_col-1, :left, matrix)
    ] |>
    Enum.uniq() |>
    Enum.sort(fn {a, _}, {b, _} -> a > b end) |>
    Enum.at(0)

    {part_one, updated_matrix} = res
    IO.puts("PART ONE: #{part_one/2}")

    updated_matrix = update_matrix(updated_matrix, start_row, start_col, "X")
    IO.inspect(updated_matrix)
    height = length(updated_matrix)
    width = length(Enum.at(updated_matrix, 0))
    part_two = count_enclosed(0, 0, height, width, updated_matrix)
    IO.puts("PART TWO: #{part_two}")
  end

  def count_enclosed(counter, index, height, width, updated_matrix) when index == height*width do counter end
  def count_enclosed(counter, index, height, width, updated_matrix) do
    x = div(index, width)
    y = rem(index, width)
    curr = Enum.at(updated_matrix, x) |> Enum.at(y)
    if curr == "." do
      Queue.new(:q)
      Queue.push(:q, {x, y})
      set = MapSet.new()
      set = MapSet.put(set, {x, y})
      not_enclosed = dfs(set, height, width, updated_matrix)
      Queue.delete(:q)
      if not_enclosed do
        count_enclosed(counter, index+1, height, width, updated_matrix)
      else
        count_enclosed(counter+1, index+1, height, width, updated_matrix)
      end
    else
        count_enclosed(counter, index+1, height, width, updated_matrix)
    end
  end

  def dfs(set, x, y, matrix) do
  end

  def loop_len(step, row, col, direction, matrix) do
    curr = Enum.at(matrix, row) |> Enum.at(col)
    if (curr == "S" and step != 0) or curr == "." do
      update_matrix(matrix, row, col, "X")
      {step+1, matrix}
    else
      next_move = case curr do
        "|" ->
          if direction == :up do
            {row-1, col, :up}
          else
            {row+1, col, :down}
          end
        "-" ->
          if direction == :right do
            {row, col+1, :right}
          else
            {row, col-1, :left}
          end
        "L" ->
          if direction == :left do
            {row-1, col, :up}
          else
            {row, col+1, :right}
          end
        "J" ->
          if direction == :down do
            {row, col-1, :left}
          else
            {row-1, col, :up}
          end
        "7" ->
          if direction == :up do
            {row, col-1, :left}
          else
            {row+1, col, :down}
          end
        "F" ->
        if direction == :up do
          {row, col+1, :right}
        else
          {row+1, col, :down}
        end
      end
      if next_move == nil do
        -1
      else
        {new_row, new_col, new_direction} = next_move
        updated_matrix = update_matrix(matrix, row, col, "X")
        loop_len(step+1, new_row, new_col, new_direction, updated_matrix)
      end
    end
  end

  def update_matrix(matrix, row, col, char) do
    updated_row = List.replace_at(Enum.at(matrix, row), col, char)
    List.replace_at(matrix, row, updated_row)
  end

  def find_start(row, [head | tail]) do
    col = head |>
    Enum.with_index() |>
    Enum.reduce_while(-1, fn {char, i}, acc ->
      if char == "S" do
        {:halt, i}
      else
        {:cont, -1}
      end
    end)
    if col != -1 do
      {row, col}
    else
      find_start(row+1, tail)
    end
  end
end
