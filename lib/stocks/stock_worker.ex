defmodule Stocks.StockWorker do
  use GenServer

  require Logger

  def init(state) do
    Logger.info("Starting up, #{state.stock}")

    state =
      state
      |> Map.put(:trade_count, 0)

    simulate_trading()
    monitor()

    {:ok, state}
  end

  def handle_info(:trade, state) do
    Logger.info("Trading! I'm #{state.stock}")

    state =
      state
      |> Map.put(:trade_count, state.trade_count + 1)

    simulate_trading()

    {:noreply, state}
  end

  def handle_info(:trade_count, state) do
    Logger.info("#{state.stock} traded #{state.trade_count} times so far")

    monitor()

    {:noreply, state}
  end

  def simulate_trading() do
    random = Enum.random(1..20)

    Process.send_after(self(), :trade, 100 * random)
  end

  def monitor() do
    Process.send_after(self(), :trade_count, 5000)
  end
end
