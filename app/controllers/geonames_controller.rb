class GeonamesController < ApplicationController
  def show
    if coords.any?
      @geoname = Geoname.search(coords, zoom)
      @photos  = FlickrSearch.get_photos(@geoname.title)
    end
  rescue
    @geoname ||= []
    @photos  ||= []
  end

  private
  def coords
    params.select { |k,*| k =~ /lat|lng/ }
  end

  def zoom
    Integer(params[:zoom] || 0)
  end
end
