class Acronym
  def self.abbreviate(text)
    text.
    upcase().
    scan(/\b\w/).
    join()
  end
end