defmodule Pixeldb do
  @moduledoc """
  Storage of `pixel` information for drawing old-school landscapes.

  The back end storage is a persistent ETS table, saved to `pixeldb.tab`.

  This is NOT an elixir application, and you must add this directly
  to your application, for example

      def start(_type, _args) do
        import Supervisor.Spec, warn: false

        children = [
          {Pixeldb.Worker, [table: "pixeldb"]
        ]

        opts = [
          strategy: :one_for_one,
          name: Pixeldb.Supervisor
        ]

        Supervisor.start_link(children, opts)
      end

  If you want to play around in the terminal, then run

      iex> {:ok, pid} = Pixeldb.Worker.start_link()

  As we did not specify a `name` for the process, the default will
  suffice and we can call all methods WITHOUT the need for a `pid`.

      iex> Pixeldb.upsert(%Pixeldb.Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#55efc4"]]})

  And then you can fetch your `"mountain"`

      iex> Pixeldb.fetch("mountain")

  And list all pixels you have stored

      iex> Pixeldb.ls()

  In the above, the default table name is `"pixeldb.tab"` and the
  default pid lookup is `Pixeldb.Worker`.  If you want to override that
  information, then do something like

      iex> {:ok, pid} = Pixeldb.Worker.start_link(table: "terrain.tab", name: :terrain)

  And maybe we wanted a second pixel database, for characters.

      iex> Pixeldb.Worker.start_link(table: "characters.tab", name: :characters)

  Now we can save terrain pixels, separately from character pixels.

      iex> mountain = %Pixeldb.Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#55efc4"]]}
      iex> character = %Pixeldb.Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#d3d3d3"]]}
      iex> Pixeldb.upsert(mountain, :terrain)
      iex> Pixeldb.upsert(mountain, :characters)

  And now we name list them separately,

      iex> Pixeldb.ls(:terrain)

  """

  alias Pixeldb.{Pixel, Bitmap, Worker}

  @doc """
  List all saved pixels by name.

  If you are managing multiple pixel databases, then
  you can provide the `pid`, otherwise it will default
  to the named worker

  ## Examples

      Pixeldb.ls()
      iex> ["mountain", "river", "desert"]

  """
  def ls(pid \\ nil) do
    GenServer.call(Worker.resolve_pid(pid), :ls)
  end

  @doc """
  List all saved pixels in their entirety.

  If you are managing multiple pixel databases, then
  you can provide the `pid`, otherwise it will default
  to the named worker

  ## Examples

      Pixeldb.ls_la()
      iex> [%Pixeldb.Pixel{name: "mountain"},
          %Pixeldb.Pixel{name: "river"},
          %Pixeldb.Pixel{name: "desert"}
        ]

  """
  def ls_la(pid \\ nil) do
    GenServer.call(Worker.resolve_pid(pid), :ls_la)
  end

  @doc """
  Retrieve a `Pixeldb.Pixel` by name.

  If you are managing multiple pixel databases, then
  you can provide the `pid`, otherwise it will default
  to the named worker

  ## Examples

      # if it exists, return it
      iex> Pixeldb.fetch("mountain")
      %Pixeldb.Pixel{
        rows: 1,
        columns: 1,
        pixels: [["#55efc4"]]
      }

      # if not, return nil
      iex> Pixeldb.fetch("river")
      nil

  """
  def fetch(name, pid \\ nil) do
    GenServer.call(Worker.resolve_pid(pid), {:fetch, name})
  end

  @doc """
  Create (or update) a `Pixeldb.Pixel` by name

  ## Examples

      # If you are building this yourself, then it should look like this
      iex> Pixeldb.upsert(%Pixeldb.Pixel{name: "mountain", rows: 1, columns: 1, pixels: [["#55efc4"]]})
      {:ok, %Pixeldb.Pixel{columns: 1, pixels: [["#55efc4"]], rows: 1}}

      # If you are coming from a web request, it might look like this
      iex> Pixeldb.upsert(%{"columns" => "3", "name" => "river", "pixels" => %{"0" => ["#55efc4", "#55efc5", ""], "1" => ["#55efc6", "#55efc7", ""], "2" => ["", "", "", ""]}, "rows" => "3"})

  """
  def upsert(pixel), do: upsert(pixel, nil)

  def upsert(
        %{"name" => name, "rows" => raw_rows, "columns" => raw_cols, "pixels" => raw_pixels},
        pid
      ) do
    raw_pixels
    |> Enum.to_list()
    |> Enum.map(fn {_, v} ->
      Enum.map(v, fn
        "" -> nil
        col -> col
      end)
    end)
    |> (fn pixels ->
          {columns, ""} = Integer.parse(raw_cols)
          {rows, ""} = Integer.parse(raw_rows)
          %Pixel{name: name, rows: rows, columns: columns, pixels: pixels}
        end).()
    |> upsert(pid)
  end

  def upsert(%Pixel{} = pixel, pid) do
    GenServer.call(Worker.resolve_pid(pid), {:upsert, pixel})
  end

  defdelegate to_bmp(pixel), to: Bitmap, as: :generate

end
