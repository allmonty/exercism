defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(Account, 0)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account), do: GenServer.cast(account, :close)

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account), do: GenServer.call(account, :get)

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount), do: GenServer.call(account, {:update, amount})
end

defmodule Account do
  use GenServer

  @error_msg {:error, :account_closed}

  @impl true
  def init(balance), do: {:ok, balance}

  @impl true
  def handle_cast(:close, _), do: {:noreply, :closed}

  @impl true
  def handle_call(:get, _, :closed), do: {:reply, @error_msg, :closed}
  @impl true
  def handle_call(:get, _, state), do: {:reply, state, state}

  @impl true
  def handle_call({:update, _}, _, :closed), do: {:reply, @error_msg, :closed}
  @impl true
  def handle_call({:update, amount}, _, state), do: {:reply, state + amount, state + amount}
end
