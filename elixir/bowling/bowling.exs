defmodule Bowling do
  defmodule Game do
    defstruct current_frame: 1,
              frames: %{
                1 => {},
                2 => {},
                3 => {},
                4 => {},
                5 => {},
                6 => {},
                7 => {},
                8 => {},
                9 => {},
                10 => {}
              }
  end

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: any
  def start, do: %Game{}

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(%Game{current_frame: 10, frames: frames}, roll) do
    %Game{
      current_frame: 10,
      frames: %{frames | 10 => Tuple.append(frames[10], roll)}
    }
  end

  def roll(%Game{current_frame: current, frames: frames}, roll) do
    case frames[current] do
      {} -> %Game{current_frame: current, frames: %{frames | current => {roll}}}
      {x} -> %Game{current_frame: current + 1, frames: %{frames | current => {x, roll}}}
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(game) do
    game.frames
    |> Enum.reduce(0, fn {frame, rolls}, acc ->
      calculate(rolls, frame, game.frames) + acc
    end)
  end

  defp calculate(rolls, frame, frames)
  defp calculate({r1, r2}, f, frames) when r1 + r2 == 10, do: r1 + r2 + elem(frames[f + 1], 0)
  defp calculate({r1, r2, r3}, _, _), do: r1 + r2 + r3
  defp calculate({r1, r2}, _, _), do: r1 + r2
  defp calculate(_, _, _), do: 0
end
