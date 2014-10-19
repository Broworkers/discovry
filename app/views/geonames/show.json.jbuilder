json.wikipedia do |wiki|
  wiki.summary @geoname.summary
  wiki.title @geoname.title
  wiki.url @geoname.wikipediaUrl
end
json.photos do |photo|
  @photos.each do |thumb, url|
    photo.thumb thumb
    photo.url url
  end
end
