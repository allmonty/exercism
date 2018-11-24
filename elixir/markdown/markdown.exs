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
    |> Enum.join()
    |> patch()
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

  defp process_words(t), do: t |> String.split() |> join_words_with_tags()

  defp join_words_with_tags(t) do
    t
    |> Enum.map(&replace_md_with_tag/1)
    |> Enum.join(" ")
  end

  defp replace_md_with_tag(w) do
    w |> replace_prefix_md() |> replace_suffix_md()
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end

  defp patch(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end

  defp header?(t), do: t =~ ~r/^#+\s/
  defp list?(t), do: String.starts_with?(t, "* ")

  defp header(t, level), do: "<h#{level}>#{t}</h#{level}>"
  defp list_item(t), do: "<li>#{t}</li>"
  defp paragraph(t), do: "<p>#{t}</p>"

  defp split_per_line(t), do: String.split(t, "\n")
end
