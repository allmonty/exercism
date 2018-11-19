defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand([hand]), do: [hand]
  def best_hand(hands), do: best(hands)

  defp best(hands) do
    hands
    |> Enum.map(&Hand.new/1)
    |> highest_card_hand()
  end

  defp highest_card_hand(hands) do
    Enum.reduce(hands, {[], 0}, fn hand, {list, current} ->
      card = highest_card(hand)

      cond do
        card > current -> {[hand.hand], card}
        card == current -> {[hand.hand | list], card}
        true -> {list, current}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp highest_card(hand), do: Enum.max_by(hand.ranks, fn {key, _} -> key end) |> elem(0)
end

defmodule Hand do
  defstruct ranks: %{}, suits: %{}, hand: []

  def new(list) do
    list
    |> Enum.reduce(%Hand{}, fn x, acc ->
      {rank, suit} = String.split_at(x, String.length(x) - 1)
      ranks = Map.update(acc.ranks, rank_to_int(rank), 1, &(&1 + 1))
      suits = Map.update(acc.suits, suit, 1, &(&1 + 1))
      %{acc | ranks: ranks, suits: suits}
    end)
    |> Map.put(:hand, list)
  end

  defp rank_to_int(rank) do
    case rank do
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      "A" -> 1
      n -> String.to_integer(n)
    end
  end
end
