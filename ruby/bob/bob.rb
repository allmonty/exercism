class Bob
  def self.hey(text)
    case text.gsub(/[\s\d,]/, "")
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