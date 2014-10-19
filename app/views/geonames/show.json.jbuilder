@geonames.each do |geoname|
  json[geoname, :lat, :lng]
end
