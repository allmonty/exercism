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
      header?(t) -> t |> parse_header_md_level() |> enclose_with_header_tag()
      list?(t) -> t |> parse_list_md_level()
      true -> t |> String.split() |> enclose_with_paragraph_tag()
    end
  end

  defp parse_header_md_level(hwt) do
    [header_mark | text] = String.split(hwt)

    qty_of_hash_marks = header_mark |> String.length()
    text = text |> Enum.join(" ")

    {qty_of_hash_marks, text}
  end

  defp parse_list_md_level(l) do
    l
    |> String.trim_leading("* ")
    |> String.split()
    |> join_words_with_tags()
    |> list_item()
  end

  defp enclose_with_header_tag({header_level, text}) do
    "<h#{header_level}>" <> text <> "</h#{header_level}>"
  end

  defp enclose_with_paragraph_tag(t) do
    t |> join_words_with_tags() |> paragraph()
  end

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
    |> String.replace("<li>", "<ul>" <> "<li>", global: false)
    |> String.replace_suffix("</li>", "</li>" <> "</ul>")
  end

  defp header?(t), do: String.starts_with?(t, "#")

  defp list?(t), do: String.starts_with?(t, "*")

  defp bold?(t), do: t =~ ~r/#{"__"}{1}$/

  defp italic?(t), do: t =~ ~r/[^#{"_"}{1}]/

  defp split_per_line(t), do: String.split(t, "\n")

  defp paragraph(t), do: "<p>#{t}</p>"

  defp list_item(t), do: "<li>#{t}</li>"
end
