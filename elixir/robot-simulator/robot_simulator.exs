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
    instructions
    |> String.graphemes()
    |> Enum.reduce(robot, &process/2)
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

  @dir_vectors %{north: {0, 1}, south: {0, -1}, east: {1, 0}, west: {-1, 0}}

  defp process("L", %Robot{direction: :north} = robot), do: %Robot{robot | direction: :west}
  defp process("L", %Robot{direction: :south} = robot), do: %Robot{robot | direction: :east}
  defp process("L", %Robot{direction: :east} = robot), do: %Robot{robot | direction: :north}
  defp process("L", %Robot{direction: :west} = robot), do: %Robot{robot | direction: :south}

  defp process("R", %Robot{direction: :north} = robot), do: %Robot{robot | direction: :east}
  defp process("R", %Robot{direction: :south} = robot), do: %Robot{robot | direction: :west}
  defp process("R", %Robot{direction: :east} = robot), do: %Robot{robot | direction: :south}
  defp process("R", %Robot{direction: :west} = robot), do: %Robot{robot | direction: :north}

  defp process("A", %Robot{direction: dir, position: pos}) do
    create(dir, sum_tuple(pos, @dir_vectors[dir]))
  end

  defp process(_, _), do: {:error, "invalid instruction"}

  defp sum_tuple(a, b), do: {elem(a, 0) + elem(b, 0), elem(a, 1) + elem(b, 1)}
end
