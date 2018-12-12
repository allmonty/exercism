defmodule Frame do
  defstruct r1: 0, r2: 0, r3: 0

  def update_roll(%Frame{} = frame, 1, value), do: %Frame{frame | r1: value}
  def update_roll(%Frame{} = frame, 2, value), do: %Frame{frame | r2: value}
  def update_roll(%Frame{} = frame, _, value), do: %Frame{frame | r3: value}
end

defmodule Game do
  defstruct frames: %{}, current: %{frame: 1, roll: 1}

  def new, do: %Game{frames: Enum.reduce(1..11, %{}, &Map.put(&2, &1, %Frame{}))}

  def update_frame(%Game{} = game, frame_num, roll, value) do
    updated_frame = Frame.update_roll(game.frames[frame_num], roll, value)
    updated_frames = Map.replace!(game.frames, frame_num, updated_frame)
    %Game{game | frames: updated_frames}
  end
end

defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: any
  def start, do: Game.new()

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(%Game{} = game, value) do
    process_roll(game, game.current, value)
  end

  defp process_roll(_, _, value) when value < 0,
    do: {:error, "Negative roll is invalid"}

  defp process_roll(_, _, value) when value > 10,
    do: {:error, "Pin count exceeds pins on the lane"}

  defp process_roll(_, :game_over, _), do: {:error, "Cannot roll after game is over"}

  defp process_roll(game, %{frame: 10, roll: 3}, value) do
    game
    |> Game.update_frame(10, 3, value)
    |> Map.replace!(:current, :game_over)
  end

  defp process_roll(game, %{frame: 10, roll: 2}, value) do
    cond do
      game.frames[10].r1 + value == 10 ->
        game
        |> Game.update_frame(10, 2, value)
        |> Map.replace!(:current, %{frame: 10, roll: 3})

      game.frames[10].r1 + value < 10 ->
        game
        |> Game.update_frame(10, 2, value)
        |> Map.replace!(:current, :game_over)

      true ->
        {:error, "Pin count exceeds pins on the lane"}
    end
  end

  defp process_roll(game, %{frame: 10, roll: 1}, value) do
    game
    |> Game.update_frame(10, 1, value)
    |> Map.replace!(:current, %{frame: 10, roll: 2})
  end

  defp process_roll(game, %{frame: frame, roll: 1}, 10) do
    game
    |> Game.update_frame(frame, 1, 10)
    |> Map.replace!(:current, %{frame: frame + 1, roll: 1})
  end

  defp process_roll(game, %{frame: frame, roll: 1}, value) do
    game
    |> Game.update_frame(frame, 1, value)
    |> Map.replace!(:current, %{frame: frame, roll: 2})
  end

  defp process_roll(game, %{frame: frame, roll: 2}, value) do
    if game.frames[frame].r1 + value <= 10 do
      game
      |> Game.update_frame(frame, 2, value)
      |> Map.replace!(:current, %{frame: frame + 1, roll: 1})
    else
      {:error, "Pin count exceeds pins on the lane"}
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """

  @spec score(any) :: integer | String.t()
  def score(%Game{current: :game_over} = game) do
    game.frames
    |> Enum.reduce(0, fn {index, frame}, acc ->
      frame_score(game, index, frame) + acc
    end)
  end

  def score(_), do: {:error, "Score cannot be taken until the end of the game"}

  defp frame_score(_, 10, %Frame{r1: r1, r2: r2, r3: r3}), do: r1 + r2 + r3

  defp frame_score(game, index, %Frame{r1: 10}) do
    next_frame = game.frames[index + 1]

    if next_frame.r1 == 10 do
      second_next_frame = game.frames[index + 2]
      10 + next_frame.r1 + second_next_frame.r1
    else
      10 + next_frame.r1 + next_frame.r2
    end
  end

  defp frame_score(game, index, %Frame{r1: r1, r2: r2}) when r1 + r2 == 10 do
    next_frame = game.frames[index + 1]
    10 + next_frame.r1
  end

  defp frame_score(_, _, %Frame{r1: r1, r2: r2}), do: r1 + r2
end
