class FlickrSearch
  def self.get_photos(place)
    discovered_pictures = flickr.photos.search(text: place, sort: 'relevance')
    discovered_pictures.collect { |photo| FlickRaw.url(photo) }
  end
end
