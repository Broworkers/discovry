initialize = (position) ->
  elem = $("div.map")[0]

  mapOptions =
    mapTypeControl: false
    streetViewControl: false
    panControl: false
    center: new google.maps.LatLng(-23.554113,-46.641769)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    zoom: 8

  map = new google.maps.Map(elem, mapOptions)

  updateMap = ->
    zoom = map.getZoom()
    bounds = map.getBounds()

    point = (p) -> [p.lat(), p.lng()]
    [north, east] = point(bounds.getNorthEast())
    [south, west] = point(bounds.getSouthWest())

    jQuery.ajax
      url: '/'
      success: update
      data:
        format: 'json'
        north: north
        west: west
        south: south
        east: east
        zoom: zoom

  google.maps.event.addListener map, 'dragend', ->
    do updateMap

  update = (data) ->
    $('div.content').replace(data)

$ ->
  do initialize

