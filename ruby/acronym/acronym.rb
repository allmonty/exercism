class Acronym
  def self.abbreviate(text)
    text.
    split().
    map {|word| word[0]}.
    join()
  end
end