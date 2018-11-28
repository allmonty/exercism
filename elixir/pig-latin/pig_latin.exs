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
  @vogals_sound ["xr", "yt"]

  defguard vogal_prefix(word) when binary_part(word, 0, 1) in @vogals
  defguard vogal_sound_prefix(word) when binary_part(word, 0, 2) in @vogals_sound

  defp do_translate(word) when vogal_prefix(word), do: word <> "ay"
  defp do_translate(word) when vogal_sound_prefix(word), do: word <> "ay"
  defp do_translate(word), do: word
end
