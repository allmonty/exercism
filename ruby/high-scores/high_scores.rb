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

  def personal_top()
    @scores.
    sort().
    reverse().
    slice(0..2)
  end
end