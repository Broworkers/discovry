class FlickrSearch
  def self.get_photos(place)
    flickr
      .photos
      .search(text: place, sort: 'relevance', per_page: 20)
      .collect { |photo| [FlickRaw.url_t(photo), FlickRaw.url(photo)] }
  end
end
