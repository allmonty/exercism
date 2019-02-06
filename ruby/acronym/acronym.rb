class Acronym
  def self.abbreviate(text)
    text.
    upcase().
    scan(/\w+/).
    map {|word| word[0]}.
    join()
  end
end