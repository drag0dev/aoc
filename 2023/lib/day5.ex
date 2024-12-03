defmodule Day5 do
  import Utils

  @int_max 99999999999999999999999

  def read_parts() do
    File.read!("./inputs/5.txt")
    |> String.trim
    |> String.split("\n\n")
  end

  def main() do
    parts = read_parts() |>
    Enum.map(fn map ->
      String.split(map, "\n") |>
      Enum.map(fn line -> parse_line([], 0, false, String.codepoints(line)) end)
    end) |>
    Enum.map(fn [head | tail] ->
      len = head |> length
      if len == 0 do
        tail
      else
        head ++ tail
      end
    end)

    [seed | normal_maps] = parts
    reversed_maps = Enum.reverse(normal_maps)
    seed_ranges = seed |> Enum.chunk_every(2, 2, :discard)

    Enum.to_list(1..200) |>
    Enum.reduce_while(@int_max, fn seed, acc ->
      res = dfs_part_two(seed, reversed_maps, seed_ranges)
      if length(res) > 0 do
        IO.inspect(seed)
        {:halt, Enum.min(res)}
      else
        {:cont, @int_max}
      end
    end) |>
    IO.inspect()
  end

  def check_ranges(ranges, seed) do
    ranges |>
    Enum.map(fn [start, eend] ->
      seed >= start and seed <= start + eend
    end) |>
    Enum.any?()
  end

  def mapp(curr, out_start, in_start, range) do
      if overlap(curr, curr, in_start, in_start + range) do
        out_start + curr - in_start
      else
        @int_max
      end
  end

  def dfs_part_two(curr, [], seed_ranges) do
    if check_ranges(seed_ranges, curr) do
      [curr]
    else
      []
    end
  end
  def dfs_part_two(curr, [curr_map | tail_maps], seed_ranges) do
    res = Enum.reduce(curr_map, [], fn [out_start, in_start, range], acc ->
      if overlap(curr, curr, out_start, out_start + range) do
        acc ++ dfs_part_two(in_start + curr - out_start, tail_maps, seed_ranges)
      else
        acc ++ dfs_part_two(curr, tail_maps, seed_ranges)
      end
    end)
    res
  end


  def dfs(curr, []) do curr end
  def dfs(curr, [curr_map | tail_maps]) do
    min = Enum.map(curr_map, fn [out_start, in_start, range] ->
      if overlap(curr, curr, in_start, in_start + range) do
        IO.inspect({curr, in_start, out_start, range})
        dfs(out_start + curr - in_start, tail_maps)
      else
        dfs(curr, tail_maps)
      end
    end) |>
    Enum.min()

    if min == @int_max do
      dfs(curr, tail_maps)
    else
      dfs(min, tail_maps)
    end
  end

  def overlap(a_start, a_end, b_start, b_end) do a_start <= b_end and a_end >= b_start end

  def parse_line(acc, num, flag, []) do if flag do acc ++ [num] else acc end end
  def parse_line(acc, num, flag, [head | tail]) do
    if head >= "0" and head <= "9" do
      parse_line(acc, num * 10 + String.to_integer(head), true, tail)
    else
      if flag do
        parse_line(acc ++ [num], 0, false, tail)
      else
        parse_line(acc, 0, false, tail)
      end
    end
  end
end
