defmodule BoxerboyWeb.ApiView do
  use BoxerboyWeb, :view

  def render("data.json", %{data: d}), do: d
end
