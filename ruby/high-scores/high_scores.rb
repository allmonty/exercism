class HighScores
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def latest
    @scores.last
  end

  def personal_best
    @scores.max
  end

  def personal_top
    @scores.max(3)
  end

  def report
    latest = latest()
    best = personal_best()

    "Your latest score was #{latest}. " + report_encoragement(latest, personal_best)
  end

  private

  def report_encoragement(latest_score, best_score)
    if best_score > latest_score
      difference = best_score - latest_score
      "That's #{difference} short of your personal best!"
    else
      "That's your personal best!"
    end
  end
end