defmodule Pixeldb.BitmapTest do
  use ExUnit.Case, async: true
  alias Pixeldb.{Bitmap, Pixel}

  setup do
    File.rm("test.bmp")
    File.rm("test2.bmp")
    :ok
  end

  test "hexcolor_to_rgb" do
    assert {192, 193, 194} == Bitmap.hexcolor_to_rgb("#C0C1C2")
    assert {255, 255, 255} == Bitmap.hexcolor_to_rgb(nil)
    assert {255, 255, 255} == Bitmap.hexcolor_to_rgb("donkeys")
    assert {255, 255, 255} == Bitmap.hexcolor_to_rgb("#GGGGGG")
  end

  test "generate nil" do
    assert nil == Bitmap.generate(nil)
  end

  test "generate a file (perfect 4s)" do
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
    assert expected == Bitmap.generate(pixel)
  end

  test "generate a file (needs padding)" do
    pixel = %Pixel{
      name: "ok",
      rows: 3,
      columns: 5,
      pixels: [
        ["#3498db", "#3498db", "#3498db", "#3498db", "#3498db"],
        [nil, nil, nil, nil, nil],
        ["#f1c40f", "#f1c40f", "#f1c40f", "#f1c40f", "#f1c40f"]
      ]
    }

    expected = File.read!("./test/fixtures/blue_over_orange_padding.bmp")
    assert expected == Bitmap.generate(pixel)
  end

  test "save a file (perfect 4s)" do
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

    Bitmap.save("test.bmp", pixel)
  end

  test "save a file (needs padding)" do
    pixel = %Pixel{
      name: "ok",
      rows: 3,
      columns: 5,
      pixels: [
        ["#3498db", "#3498db", "#3498db", "#3498db", "#3498db"],
        [nil, nil, nil, nil, nil],
        ["#f1c40f", "#f1c40f", "#f1c40f", "#f1c40f", "#f1c40f"]
      ]
    }

    Bitmap.save("test2.bmp", pixel)
  end
end
