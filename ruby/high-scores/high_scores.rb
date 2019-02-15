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

  def report()
    latest = latest()
    personal_best = personal_best()
    report_txt = "Your latest score was #{latest}."
    if personal_best > latest
      difference = personal_best - latest
      report_txt + " That's #{difference} short of your personal best!"
    else
      report_txt + " That's your personal best!"
    end
  end
end