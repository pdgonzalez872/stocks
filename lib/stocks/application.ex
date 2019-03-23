defmodule Stocks.Application do
  @moduledoc false

  use Application

  alias Stocks.StockWorker

  def start(_type, _args) do

    :ok = :pg2.create(:nasdaq)

    ["AAPL", "TSLA"]
    |> Enum.each(fn stock ->
      {:ok, pid} = GenServer.start_link(StockWorker, %{stock: stock})

      :ok = :pg2.join(:nasdaq, pid)
    end)

    children = [
      # Starts a worker by calling: Stocks.Worker.start_link(arg)
      # {Stocks.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Stocks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
