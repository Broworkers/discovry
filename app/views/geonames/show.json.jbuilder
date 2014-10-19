json.wikipedia do |wiki|
  wiki.summary @geoname.summary
  wiki.title @geoname.title
  wiki.url @geoname.wikipediaUrl
end

json.photos do
  json.array! @photos do |photo|
    json.thumb photo[0]
    json.url photo[1]
  end
end
