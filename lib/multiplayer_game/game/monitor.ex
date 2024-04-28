defmodule MultiplayerGame.Monitor do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def monitor(pid, view_module, meta) do
    __MODULE__
    |> GenServer.whereis()
    |> maybe_start_gen_server()

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
    views
    |> Map.pop(pid)
    |> maybe_start_task_to_unmount(reason, state)
  end

  defp maybe_start_gen_server(nil), do: start_link([])
  defp maybe_start_gen_server(_process_exist), do: :ok

  defp maybe_start_task_to_unmount({{module, meta}, new_views}, reason, state) do
    Task.start(fn ->
      try do
        module.unmount(meta, reason)
      rescue
        e -> IO.puts("Error in unmount: #{inspect(e)}")
      end
    end)

    {:noreply, %{state | views: new_views}}
  end

  defp maybe_start_task_to_unmount(_no_new_view, _reason, state), do: {:noreply, state}
end
