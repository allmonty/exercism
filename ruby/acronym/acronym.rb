class Acronym
  def self.abbreviate(text)
    text.
    upcase().
    scan(/(.)\w*\W*/).
    join()
  end
end