class HighScores
  attr_accessor :scores

  def initialize(scores)
    @scores = scores
  end

  def latest()
    @scores.last
  end

  def personal_best()
    @scores.max
  end
end