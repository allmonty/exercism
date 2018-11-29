defmodule Robot do
  defstruct position: {0, 0}, direction: :north
end

defmodule RobotSimulator do
  @valid_directions [:north, :south, :east, :west]

  defguardp valid_position(pos)
            when is_tuple(pos) and tuple_size(pos) == 2 and elem(pos, 0) |> is_integer() and
                   elem(pos, 1) |> is_integer()

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})
  def create(dir, _) when dir not in @valid_directions, do: {:error, "invalid direction"}
  def create(_, pos) when not valid_position(pos), do: {:error, "invalid position"}
  def create(direction, position), do: %Robot{direction: direction, position: position}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position
end
