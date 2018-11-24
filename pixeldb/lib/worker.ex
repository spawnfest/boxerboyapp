defmodule Pixeldb.Worker do
  use GenServer
  use FnExpr
  alias GenServer, as: GS
  alias Pixeldb.Pixel

  def start_link(opts \\ []) do
    {:ok, _pid} = GS.start_link(__MODULE__, opts[:table], name: resolve_pid(opts))
  end

  def init(tablename) do
    pid = PersistentEts.new(:pixeldb, tablename || "pixeldb.tab", [:set, :protected])
    {:ok, [table: pid, pixels: restore_pixels(pid)]}
  end

  def handle_call({:upsert, %Pixel{} = pixel}, _from, state) do
    :ets.insert(state[:table], {pixel.name, pixel})
    PersistentEts.flush(state[:table])

    state[:pixels]
    |> Map.put(pixel.name, pixel)
    |> invoke({:reply, {:ok, pixel}, Keyword.put(state, :pixels, &1)})
  end

  def handle_call({:fetch, name}, _from, state) do
    {:reply, state[:pixels][name], state}
  end

  def handle_call(:ls, _from, state) do
    {:reply, state[:pixels] |> Map.keys(), state}
  end

  def handle_call(:ls_la, _from, state) do
    state[:pixels]
    |> Map.values()
    |> Enum.sort_by(& &1.name)
    |> (fn pixels ->
          {:reply, pixels, state}
        end).()
  end

  defp restore_pixels(pid) do
    pid
    |> :ets.tab2list()
    |> Enum.into(%{})
  end

  def resolve_pid(opts) when is_list(opts), do: resolve_pid(opts[:name])
  def resolve_pid(pid), do: pid || Pixeldb.Worker
end
