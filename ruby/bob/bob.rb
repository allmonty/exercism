class Bob
  def self.hey(text)
    case text.gsub(/[^a-bA-Z?!.,]/, "")
    when ""
      "Fine. Be that way!"
    when /^[A-Z]+\?+$/
      "Calm down, I know what I'm doing!"
    when /^[A-Z]+\!*$/
      "Whoa, chill out!"
    when /\?$/
      "Sure."
    else
      "Whatever."
    end
  end
end