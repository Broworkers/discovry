require 'flickraw'

class FlickrSearch
  def self.get_photos(place)
    flickr
      .photos
      .search(text: place, sort: 'relevance', per_page: 45)
      .collect { |photo| [FlickRaw.url_s(photo), FlickRaw.url_photopage(photo)] }
  end
end
