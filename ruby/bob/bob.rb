class Bob
  def self.hey(text)
    case text
    when /^[A-Z\s]+!*$/
      "Whoa, chill out!"
    when /\?$/
      "Sure."
    else
      "Whatever."
    end
  end
end