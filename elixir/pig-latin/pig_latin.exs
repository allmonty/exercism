defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map_join(" ", &do_translate/1)
  end

  @vogals ["a", "e", "i", "o", "u"]
  @x_y ["x", "y"]

  defguard vowel_prefix(word) when binary_part(word, 0, 1) in @vogals

  defguard x_y_prefix(word) when binary_part(word, 0, 1) in @x_y
  defguard second_not_vowel(word) when binary_part(word, 1, 1) not in @vogals

  defguard vowel_like(word) when x_y_prefix(word) and second_not_vowel(word)

  defguard two_letter_suffix_y(word) when byte_size(word) == 2 and binary_part(word, 1, 1) == "y"

  defguard vowel_sound(w) when vowel_prefix(w) or vowel_like(w) or two_letter_suffix_y(w)

  defp do_translate(word) when vowel_sound(word), do: word <> "ay"

  defp do_translate(word) do
    %{"consonants" => cons, "rest" => rest} = split_consonants_prefix(word)

    case {String.last(cons) == "q", rest} do
      {true, "u" <> rest} -> rest <> cons <> "uay"
      _ -> rest <> cons <> "ay"
    end
  end

  defp split_consonants_prefix(word) do
    Regex.named_captures(~r/^(?<consonants>[^aeiou]+)(?<rest>.*)/, word)
  end
end
