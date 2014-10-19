class GeonamesController < ApplicationController
  def show
    @geoname = Geoname.search(coords, zoom) if coords.any?
  end

  private
  def coords
    params.select { |k,*| k =~ /lat|lng/ }
  end

  def zoom
    Integer(params[:zoom] || 0)
  end
end
