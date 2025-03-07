module ApplicationHelper
  def score_color(score)
    if score == "-"
      return "text-gray"
    elsif score > 80
      return "text-success"
    elsif score > 50
      return "text-info"
    else
      return "text-danger"
    end
  end
end
