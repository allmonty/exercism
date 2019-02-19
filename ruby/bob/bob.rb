class Bob
  def self.hey(text)
    text = clean_text(text)

    if text == ""
      "Fine. Be that way!"
    elsif yelling?(text) && question?(text)
      "Calm down, I know what I'm doing!"
    elsif yelling?(text)
      "Whoa, chill out!"
    elsif question?(text)
      "Sure."
    else
      "Whatever."
    end
  end

  private

  def self.clean_text(text) text.gsub(/[^a-zA-Z?!\d]/, "") end
  
  def self.question?(text) text =~ /\?+$/ end
    
  def self.yelling?(text)
    text = text.gsub(/[\d,? ]/, "")
    text =~ /^[A-Z]+[!]*$/
  end
end