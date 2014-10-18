initialize = ->
  elem = $("div.map")[0]

  mapOptions =
    center: new google.maps.LatLng(-34.397, 150.644)
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(elem, mapOptions)

  google.maps.event.addListener map, 'dragend', ->
    console.log map.getCenter()

$ ->
  do initialize
