module JobsHelper

  def badge_class_for_status(status)
    if status === "running"
      "badge badge-info"
    elsif status === "completed"
      "text-success"
    elsif status === "queued"
      "badge badge-warning"
    elsif status === "failed"
      "badge badge-important"
    elsif status === "canceled"
      "text-error"
    else
      ""
    end
  end

end