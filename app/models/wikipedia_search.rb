require 'wikipedia'
require 'ostruct'

class WikipediaSearch
  def self.get_info(lang, place)
    Wikipedia.Configure { domain "#{lang}.wikipedia.org" }
    result = Wikipedia.find(place)

    OpenStruct.new \
      title: result.title,
      content: result.sanitized_content,
      result: result
  end
end
