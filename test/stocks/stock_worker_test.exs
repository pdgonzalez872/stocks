defmodule Stocks.StockWorkerTest do
  use ExUnit.Case

  alias Stocks.StockWorker

  test "greets the world" do

    :ok = :pg2.create(:nasdaq)

    {:ok, pid} = GenServer.start_link(StockWorker, %{stock: "AAPL"})

    :ok = :pg2.join(:nasdaq, pid)

    :pg2.get_members(:nasdaq)
    |> Enum.each(fn worker -> GenServer.cast(worker, :trade) end)

    pid
    |> inspect()

    assert pid == 0
  end
end
