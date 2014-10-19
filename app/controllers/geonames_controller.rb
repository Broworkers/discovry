class GeonamesController < ApplicationController
  def show
    @geonames = Geoname.search(coords, zoom) if coords.any?
  end

  private
  def coords
    params.select { |k,*| k =~ /north|west|south|east/ }
  end

  def zoom
    Integer(params[:zoom] || 0)
  end
end
