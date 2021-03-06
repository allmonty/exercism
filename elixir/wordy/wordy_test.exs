if !System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("wordy.exs", __DIR__)
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule WordyTest do
  use ExUnit.Case

  test "addition" do
    assert Wordy.answer("What is 1 plus 1?") == 2
  end

  # @tag :pending
  test "more addition" do
    assert Wordy.answer("What is 53 plus 2?") == 55
  end

  # @tag :pending
  test "addition with negative numbers" do
    assert Wordy.answer("What is -1 plus -10?") == -11
  end

  # @tag :pending
  test "large addition" do
    assert Wordy.answer("What is 123 plus 45678?") == 45801
  end

  # @tag :pending
  test "subtraction" do
    assert Wordy.answer("What is 4 minus -12?") == 16
  end

  # @tag :pending
  test "multiplication" do
    assert Wordy.answer("What is -3 multiplied by 25?") == -75
  end

  # @tag :pending
  test "division" do
    assert Wordy.answer("What is 33 divided by -3?") == -11
  end

  # @tag :pending
  test "multiple additions" do
    assert Wordy.answer("What is 1 plus 1 plus 1?") == 3
  end

  # @tag :pending
  test "addition and subtraction" do
    assert Wordy.answer("What is 1 plus 5 minus -2?") == 8
  end

  # @tag :pending
  test "multiple subtraction" do
    assert Wordy.answer("What is 20 minus 4 minus 13?") == 3
  end

  # @tag :pending
  test "subtraction then addition" do
    assert Wordy.answer("What is 17 minus 6 plus 3?") == 14
  end

  # @tag :pending
  test "multiple multiplication" do
    assert Wordy.answer("What is 2 multiplied by -2 multiplied by 3?") == -12
  end

  # @tag :pending
  test "addition and multiplication" do
    assert Wordy.answer("What is -3 plus 7 multiplied by -2?") == -8
  end

  # @tag :pending
  test "multiple division" do
    assert Wordy.answer("What is -12 divided by 2 divided by -3?") == 2
  end

  # @tag :pending
  test "unknown operation" do
    assert_raise ArgumentError, fn ->
      Wordy.answer("What is 52 cubed?")
    end
  end

  # @tag :pending
  test "Non math question" do
    assert_raise ArgumentError, fn ->
      Wordy.answer("Who is the President of the United States?")
    end
  end

  # @tag :pending
  test "exponential" do
    assert Wordy.answer("What is 2 raised to the 5th power?") == 32
  end

  # @tag :pending
  test "multiple exponential" do
    assert Wordy.answer("What is 2 raised to the 5th power raised to the 2th power?") == 1024
  end

  # @tag :pending
  test "exponential and sum" do
    assert Wordy.answer("What is 2 raised to the 5th power plus 3?") == 35
  end

  test "floats" do
    assert Wordy.answer("What is 1.2 plus 1.3?") == 2.5
    assert Wordy.answer("What is 1,2 plus 1,3?") == 2.5
  end

  test "sentence with just one word" do
    assert_raise ArgumentError, fn ->
      Wordy.answer("What")
    end
  end

  test "malformed question" do
    q1 = "What is X plus 3?"
    q2 = "What is 3 minus X?"
    q3 = "What is X multiplied by 3?"
    q4 = "What is X divided by 3?"
    q5 = "What is X raised to the 3rd power?"

    assert_raise ArgumentError, fn -> Wordy.answer(q1) end
    assert_raise ArgumentError, fn -> Wordy.answer(q2) end
    assert_raise ArgumentError, fn -> Wordy.answer(q3) end
    assert_raise ArgumentError, fn -> Wordy.answer(q4) end
    assert_raise ArgumentError, fn -> Wordy.answer(q5) end
  end
end
