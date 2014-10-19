initialize = (position) ->
  elem = $("div.map")[0]

  mapOptions =
    mapTypeControl: false
    streetViewControl: false
    panControl: false
    center: new google.maps.LatLng(-23.554113,-46.641769)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    zoom: 7

  map = new google.maps.Map(elem, mapOptions)

  updateMap = ->
    zoom = map.getZoom()
    bounds = map.getBounds()

    console.log zoom
    console.log bounds

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

  setTimeout updateMap, 500
  google.maps.event.addListener map, 'dragend', updateMap
  google.maps.event.addListener map, 'zoom_changed', updateMap

  markers = []
  infos = []

  mark = (point) ->
    marker = new google.maps.Marker
      position:
        title: point.name
        lat: Number(point.lat)
        lng: Number(point.lng)
      map: map
    markers.push(marker)

    google.maps.event.addListener marker, 'click', ->
      info = new google.maps.InfoWindow
        content: "#{point.name} (#{point.population})"

      info.open(map, marker)
      infos.push(info)

  update = (points) ->
    marker.setMap(null) for marker in markers
    info.close() for info in infos

    [markers, infos] = [[], []]
    mark(point) for point in points

$(initialize)
