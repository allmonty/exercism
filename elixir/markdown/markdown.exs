defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> split_per_line()
    |> Enum.map(&process/1)
    |> enclose_lists()
    |> Enum.join()
  end

  defp process(t) do
    cond do
      header?(t) -> t |> process_header()
      list?(t) -> t |> process_list()
      true -> t |> process_words() |> paragraph()
    end
  end

  defp process_header(t, level \\ 1)
  defp process_header("# " <> t, level), do: header(t, level)
  defp process_header("#" <> t, level), do: process_header(t, level + 1)

  defp process_list("* " <> t), do: t |> process_words() |> list_item()

  defp process_words(t), do: t |> join_words_with_tags()

  defp join_words_with_tags(t) do
    t
    |> String.split()
    |> Enum.map(&put_strong_or_italic_tag/1)
    |> Enum.join(" ")
  end

  defp put_strong_or_italic_tag(w) do
    w
    |> String.replace_prefix("__", "<strong>")
    |> String.replace_prefix("_", "<em>")
    |> String.replace_suffix("__", "</strong>")
    |> String.replace_suffix("_", "</em>")
  end

  defp enclose_lists(list, processed_list \\ [], is_processing_list \\ false)

  defp enclose_lists([], p, _), do: p |> Enum.reverse()

  defp enclose_lists([h | t], p, false) do
    case String.starts_with?(h, "<li>") do
      true -> enclose_lists(t, ["<ul>#{h}" | p], true)
      false -> enclose_lists(t, [h | p], false)
    end
  end

  defp enclose_lists(["<li>" <> h], p, true), do: enclose_lists([], ["<li>#{h}</ul>" | p], true)

  defp enclose_lists([h | t], p, true) do
    case String.starts_with?(h, "<li>") do
      true -> enclose_lists(t, [h | p], true)
      false -> enclose_lists(t, ["</ul>" <> h | p], false)
    end
  end

  defp header?(t), do: t =~ ~r/^#+\s/
  defp list?(t), do: String.starts_with?(t, "* ")

  defp header(t, level), do: "<h#{level}>#{t}</h#{level}>"
  defp list_item(t), do: "<li>#{t}</li>"
  defp paragraph(t), do: "<p>#{t}</p>"

  defp split_per_line(t), do: String.split(t, "\n")
end
