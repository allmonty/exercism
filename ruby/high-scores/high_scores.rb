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
    create_report_text(
      latest(),
      personal_best()
    )
  end

  private

  def create_report_text(latest_score, best_score)
    report_txt = "Your latest score was #{latest_score}."

    if best_score > latest_score
      difference = best_score - latest_score
      report_txt + " That's #{difference} short of your personal best!"
    else
      report_txt + " That's your personal best!"
    end
  end
end