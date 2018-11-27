defmodule Markdown do
  alias Markdown.AfterProcess

  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown_text) do
    markdown_text
    |> split_per_line()
    |> Enum.map(&process/1)
    |> AfterProcess.enclose_lis()
    |> Enum.join()
  end

  defp process("#" <> text), do: text |> process_words() |> process_header()
  defp process("* " <> text), do: text |> process_words() |> list_item()
  defp process(text), do: text |> process_words() |> paragraph()

  defp process_header(text, level \\ 1)
  defp process_header(" " <> text, level), do: header(text, level)
  defp process_header("#" <> text, level), do: process_header(text, level + 1)

  defp process_words(text), do: text |> bold() |> italic()

  defp header(text, level), do: "<h#{level}>#{text}</h#{level}>"
  defp list_item(text), do: "<li>#{text}</li>"
  defp paragraph(text), do: "<p>#{text}</p>"

  defp bold(text), do: String.replace(text, ~r/__([^_]+)__/, "<strong>\\1</strong>")
  defp italic(text), do: String.replace(text, ~r/_([^_]+)_/, "<em>\\1</em>")

  defp split_per_line(text), do: String.split(text, "\n")
end

defmodule Markdown.AfterProcess do
  defguard li_prefix(text) when binary_part(text, 0, 4) == "<li>"

  def enclose_lis(list_of_text_lines, processed_list \\ [], is_processing_list \\ false)

  def enclose_lis([], processed_list, _), do: processed_list |> Enum.reverse()

  def enclose_lis([h], p, true) when li_prefix(h), do: enclose_lis([], ["#{h}</ul>" | p], true)
  def enclose_lis([h | t], p, true) when li_prefix(h), do: enclose_lis(t, [h | p], true)
  def enclose_lis([h | t], p, true), do: enclose_lis(t, ["</ul>" <> h | p], false)

  def enclose_lis([h | t], p, false) when li_prefix(h), do: enclose_lis(t, ["<ul>#{h}" | p], true)
  def enclose_lis([h | t], p, false), do: enclose_lis(t, [h | p], false)
end
