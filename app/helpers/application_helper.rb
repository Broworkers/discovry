module ApplicationHelper
  def format_result(content)
    removed_tags = strip_tags(content || "")
    removed_wikis = remove_wiki_code(removed_tags)

    get_main_content(removed_wikis)
  end


  def remove_wiki_code(text)
    text
      .gsub(/==.*==/, '')
      .gsub(/\[\d*\]/, '')
      .gsub('*', '')
      .gsub(/\(.*\)/, '')
  end

  def get_main_content(text)
    value = text.split('.') + ["", ""]
    value[0..2].join(".")
  end
end
