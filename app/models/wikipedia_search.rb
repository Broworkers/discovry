require 'ostruct'

class WikipediaSearch
  def initialize(lang, place)
    @lang = lang
    @place = place

    populate
  end

  def available?
    summary.present?
  end

  def populate
    @content = query_endpoint(@place)
    @pageinfo = query_pageurl
  end

  def title
    result["title"]
  end

  def summary
    result["extract"].gsub(/\(.*\)/, '')
  end

  def result
    @content["query"]["pages"].first.last
  end

  def url
    @pageinfo["query"]["pages"].first.last["fullurl"]
  end

  private
  def page_id
    result["pageid"]
  end

  def pageurl(json)
    json["query"]["pages"].first.last["fullurl"]
  end

  def query_pageurl
    get("http://#{@lang}.wikipedia.org/w/api.php?action=query&prop=info&pageids=#{page_id}&inprop=url&format=json")
  end

  def query_endpoint(place)
    get("http://#{@lang}.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=#{place}&exsentences=2&redirects=")
  end

  def get(url)
    parse(RestClient.get(URI.escape(url)))
  end

  def parse(result)
    JSON[result]
  end
end
