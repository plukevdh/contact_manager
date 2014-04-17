module ApplicationHelper

  # helper to format the <title> tag in the head block
  def title(title)
    @title = "#{title} - "
  end
end
