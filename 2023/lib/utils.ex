defmodule Utils do
  def read_from_file(day) do
    File.read!("./inputs/#{day}.txt")
    |> String.split("\n")
  end
end
