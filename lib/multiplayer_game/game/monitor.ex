defmodule MultiplayerGame.Monitor do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def monitor(pid, view_module, meta) do
    case GenServer.whereis(__MODULE__) do
      nil -> start_link([])
      _ -> :ok
    end

    GenServer.call(__MODULE__, {:monitor, pid, view_module, meta})
  end

  def init(_) do
    {:ok, %{views: %{}}}
  end

  def handle_call({:monitor, pid, view_module, meta}, _, %{views: views} = state) do
    Process.monitor(pid)
    {:reply, :ok, %{state | views: Map.put(views, pid, {view_module, meta})}}
  end

  def handle_info({:DOWN, _ref, :process, pid, reason}, %{views: views} = state) do
    case Map.pop(views, pid) do
      {{module, meta}, new_views} ->
        Task.start(fn ->
          try do
            module.unmount(meta, reason)
          rescue
            e -> IO.puts("Error in unmount: #{inspect(e)}")
          end
        end)

        {:noreply, %{state | views: new_views}}

      _ ->
        {:noreply, state}
    end
  end
end
