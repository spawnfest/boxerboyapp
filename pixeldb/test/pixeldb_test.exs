defmodule PixeldbTest do
  use ExUnit.Case, async: true
  alias Pixeldb.{Pixel, Worker}

  setup do
    File.rm("pixeldb.tab")
    File.rm("pixeldb_1.tab")
    File.rm("pixeldb_2.tab")
    :ok
  end

  test "fetch existig pixel" do
    pid = worker()
    pixel = %Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#3d3d3d"]]}
    Pixeldb.upsert(pixel, pid)
    assert pixel == Pixeldb.fetch("mountain", pid)

    assert ["mountain"] == Pixeldb.ls(pid)
  end

  test "persist pixels for restart" do
    pid1 = worker(table: "pixeldb_1.tab")

    p1 = %Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#3d3d3d"]]}
    p2 = %Pixel{name: "desert", rows: 1, columns: 1, pixels: [["#4d4d4d"]]}

    Pixeldb.upsert(p1, pid1)
    Pixeldb.upsert(p2, pid1)

    Process.exit(pid1, :normal)

    pid2 = worker(table: "pixeldb_1.tab")
    assert p1 == Pixeldb.fetch("mountain", pid2)
    assert p2 == Pixeldb.fetch("desert", pid2)
  end

  test "upsert based on encoded JSON" do
    pid = worker(table: "pixeldb_2.tab")

    raw_pixel = %{
      "columns" => "3",
      "name" => "river",
      "pixels" => %{
        "0" => ["#55efc4", "#55efc5", ""],
        "1" => ["#55efc6", "#55efc7", nil],
        "2" => ["", "", ""]
      },
      "rows" => "3"
    }

    struct_pixel = %Pixel{
      name: "river",
      rows: 3,
      columns: 3,
      pixels: [["#55efc4", "#55efc5", nil], ["#55efc6", "#55efc7", nil], [nil, nil, nil]]
    }

    Pixeldb.upsert(raw_pixel, pid)
    assert struct_pixel == Pixeldb.fetch("river", pid)
  end

  def worker(opts \\ []) do
    opts
    |> Keyword.put(:name, "t#{:rand.uniform(10)}" |> String.to_atom())
    |> Worker.start_link()
    |> case do
      {:ok, pid} -> pid
    end
  end
end
