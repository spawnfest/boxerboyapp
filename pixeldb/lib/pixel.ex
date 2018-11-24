defmodule Pixeldb.Pixel do
  @derive Jason.Encoder
  defstruct name: nil, rows: 0, columns: 0, pixels: []
end
