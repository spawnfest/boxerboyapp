defmodule Pixeldb.Bitmap do
  @moduledoc """
  Generate a bitmap file based on the pixel data.

  This is many thanks to
  https://alchemist.camp/episodes/bitmaps-elixir

  And for technical details, you can read
  http://www.fileformat.info/format/bmp/egff.htm
  """

  alias Pixeldb.Pixel

  def generate(nil), do: nil
  def generate(%Pixel{} = pixel) do
    file_header() <> win2x_header(pixel.columns, pixel.rows) <> pixel_data(pixel)
  end

  def save(filename, %Pixel{} = pixel) do
    File.write!(filename, pixel |> generate())
  end

  def file_header(offset \\ 26) do
    file_type = "BM"
    # if not compressed, doesn't matter
    file_size = <<0::little-size(32)>>
    # always 0
    reserved1 = <<0::little-size(16)>>
    # always 0
    reserved2 = <<0::little-size(16)>>
    bitmap_offset = <<offset::little-size(32)>>
    file_type <> file_size <> reserved1 <> reserved2 <> bitmap_offset
  end

  def win2x_header(width, height, bits_per_pixel \\ 24) do
    size = <<12::little-size(32)>>
    width = <<width::little-size(16)>>
    height = <<height::little-size(16)>>
    planes = <<1::little-size(16)>>
    bpp = <<bits_per_pixel::little-size(16)>>
    size <> width <> height <> planes <> bpp
  end

  def hexcolor_to_rgb(nil), do: {255, 255, 255}

  def hexcolor_to_rgb(hex) do
    Regex.scan(~r/\#([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})/, hex)
    |> case do
      [[_, r, g, b]] -> {hex_to_rbg(r), hex_to_rbg(g), hex_to_rbg(b)}
      _ -> {255, 255, 255}
    end
  end

  defp pixel_data(%Pixel{} = pixel) do
    padding =
      (3 * pixel.columns)
      |> rem(4)
      |> case do
        0 -> 0
        over -> (4 - over) * 8
      end

    for row <- pixel.pixels |> Enum.reverse(), into: <<>> do
      for hexcolor <- row, into: <<>> do
        hexcolor
        |> hexcolor_to_rgb()
        |> rgb_to_bitdata()
      end <> <<0::size(padding)>>
    end
  end

  defp rgb_to_bitdata({r, g, b}) do
    <<b::little-size(8), g::little-size(8), r::little-size(8)>>
  end

  defp rgb_to_bitdata(_), do: rgb_to_bitdata({255, 255, 255})

  defp hex_to_rbg(nil), do: 255

  defp hex_to_rbg(c) do
    c
    |> Integer.parse(16)
    |> case do
      {n, ""} -> n
      _ -> nil
    end
  end
end
