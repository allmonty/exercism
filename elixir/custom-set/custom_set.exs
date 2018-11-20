defmodule CustomSet do
  defstruct data: []

  @opaque t :: %__MODULE__{data: []}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    %CustomSet{data: enumerable |> Enum.uniq() |> Enum.sort()}
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    Enum.empty?(custom_set.data)
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    Enum.any?(custom_set.data, &(&1 == element))
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    Enum.all?(custom_set_1.data, &(&1 in custom_set_2.data))
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    !Enum.any?(custom_set_1.data, &(&1 in custom_set_2.data))
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    custom_set_1 == custom_set_2
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    new([element | custom_set.data])
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    data = Enum.filter(custom_set_1.data, &(&1 in custom_set_2.data))
    %CustomSet{data: data}
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    data = Enum.filter(custom_set_1.data, &(&1 not in custom_set_2.data))
    %CustomSet{data: data}
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    new(custom_set_1.data ++ custom_set_2.data)
  end
end
