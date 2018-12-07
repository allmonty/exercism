class Acronym
  def self.abbreviate(text)
    text.
    upcase().
    split(%r{[\s-]}).
    map {|word| word[0]}.
    join()
  end
end