class Bob
  def self.hey(text)
    case text
    when /.*/
      "Whatever."
    end
  end
end