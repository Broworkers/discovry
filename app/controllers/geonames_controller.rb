class GeonamesController < ApplicationController
  def show
    if coords.any?
      @geoname = Geoname.search(coords, zoom)
      # @photos  = FlickrSearch.get_photos(search)
    end

    render partial: 'content' if request.xhr?
  end

  private
  def coords
    params.select { |k,*| k =~ /lat|lng/ }
  end

  def zoom
    Integer(params[:zoom] || 0)
  end
end
