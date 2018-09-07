defmodule LambdaCache do
  @moduledoc ~S"""
  Zero-arity function polling cache.
  """

  @callback refresh :: any()
  @callback interval :: non_neg_integer()

  defmacro __using__(options) do
    quote location: :keep do
      @behaviour LambdaCache

      use GenServer

      def child_spec(args \\ nil) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [args]}
        }
      end

      def start_link(args) do
        GenServer.start_link(__MODULE__, args, Keyword.merge([name: __MODULE__], unquote(options)))
      end

      def interval do
        1000 * 60 * 5
      end

      defoverridable interval: 0

      def init(args) do
        {:ok, %{data: refresh(), timer: schedule_refresh(self(), interval())}}
      end

      def handle_call(:retrieve, _, state) do
        {:reply, state.data, state}
      end

      def handle_info(:refresh, %{timer: old_timer}) do
        Process.cancel_timer(old_timer)

        {:noreply, %{data: refresh(), timer: schedule_refresh(self(), interval())}}
      end

      def retrieve(pid \\ __MODULE__) do
        GenServer.call(pid, :retrieve)
      end

      @doc ~S"""
      Schedule a cache refresh in `n` milliseconds.
      """
      def schedule_refresh(pid, n \\ 1) do
        Process.send_after(pid, :refresh, n)
      end
    end
  end
end
