defmodule PixeldbTest do
  use ExUnit.Case, async: true
  alias Pixeldb.{Pixel, Worker}

  setup_all do
    File.rm("pixeldb.tab")
    File.rm("pixeldb_1.tab")
    File.rm("pixeldb_2.tab")
    File.rm("pixeldb_3.tab")
    File.rm("pixeldb_4.tab")
    :ok
  end

  test "fetch existig pixel" do
    pid = worker()
    pixel = %Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#3d3d3d"]]}
    Pixeldb.upsert(pixel, pid)
    assert pixel == Pixeldb.fetch("mountain", pid)

    assert ["mountain"] == Pixeldb.ls(pid)

    assert [%Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#3d3d3d"]]}] ==
             Pixeldb.ls_la(pid)
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

  test "upsert properly sort string numbers" do
    pid = worker(table: "pixeldb_3.tab")

    raw_pixel = %{
      "columns" => "3",
      "name" => "river",
      "pixels" => %{
        "0" => ["#55efc4", "#55efc5", ""],
        "1" => ["#55efc6", "#55efc7", nil],
        "2" => ["#55efc6", "#55efc7", ""],
        "3" => ["#55efc6", "#55efc7", ""],
        "4" => ["", "", ""],
        "5" => ["", "", ""],
        "6" => ["", "", ""],
        "7" => ["", "", ""],
        "8" => ["", "", ""],
        "9" => ["", "", ""],
        "10" => ["", "", ""],
        "11" => ["", "", ""],
        "12" => ["", "", ""]
      },
      "rows" => "3"
    }

    struct_pixel = %Pixel{
      name: "river",
      rows: 3,
      columns: 3,
      pixels: [
        ["#55efc4", "#55efc5", nil],
        ["#55efc6", "#55efc7", nil],
        ["#55efc6", "#55efc7", nil],
        ["#55efc6", "#55efc7", nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    }

    Pixeldb.upsert(raw_pixel, pid)
    assert struct_pixel == Pixeldb.fetch("river", pid)
  end

  test "to_bmp handles nil" do
    assert nil == Pixeldb.to_bmp(nil)
  end

  test "to_bmp generates a file" do
    pixel = %Pixel{
      name: "ok",
      rows: 4,
      columns: 4,
      pixels: [
        ["#3498db", "#3498db", "#3498db", "#3498db"],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        ["#f1c40f", "#f1c40f", "#f1c40f", "#f1c40f"]
      ]
    }

    expected = File.read!("./test/fixtures/blue_over_orange.bmp")
    assert expected == Pixeldb.to_bmp(pixel)
  end

  test "delete pixel" do
    pid = worker(table: "pixeldb_4.tab")
    assert nil == Pixeldb.delete("missing_pixel", pid)

    pixel1 = %Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#3d3d3d"]]}
    pixel2 = %Pixel{name: "river", rows: 1, columns: 1, pixels: [["#3d3d3e"]]}
    Pixeldb.upsert(pixel1, pid)
    Pixeldb.upsert(pixel2, pid)

    assert pixel2 == Pixeldb.delete("river", pid)
    assert nil == Pixeldb.fetch("river", pid)
    assert pixel1 == Pixeldb.fetch("mountain", pid)
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
