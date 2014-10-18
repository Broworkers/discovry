module ApplicationHelper
  def format_result(content)
    truncate(strip_tags(content).gsub(/\[\d*\]/, ''), length: 1000)
  end
end
