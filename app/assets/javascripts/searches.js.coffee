getType = (name) ->
  (results) ->
    for result in results
      for type in result.types when type is name
        for address in result.address_components
          for address_type in address.types when address_type is name
            return address.long_name

getCountry = getType('country')
getRegion = getType('administrative_area_level_1')
getCity = getType('administrative_area_level_2')
getStreet = (results) ->

initialize = ->
  elem = $("div.map")[0]

  mapOptions =
    mapTypeControl: false
    streetViewControl: false
    panControl: false
    center: new google.maps.LatLng(-23.554113,-46.641769)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    zoom: 8

  map = new google.maps.Map(elem, mapOptions)
  geocoder = new google.maps.Geocoder()

  updateMap = ->
    zoom = map.getZoom()
    curr = map.getCenter()

    geocoder.geocode 'latLng': curr, (results, status) ->
      return if status isnt google.maps.GeocoderStatus.OK
      # console.log results

      switch
        # Street
        when zoom > 15
          address = getStreet(results)
        # City
        when zoom > 10
          address = getCity(results)
        # Region
        when zoom > 5
          address = getRegion(results)
        # Country
        else
          address = getCountry(results)

      update = (data) ->
        $('div.content').replaceWith(data)

      jQuery.get('/', place: address, update)


  do updateMap

  google.maps.event.addListener map, 'dragend', ->
    do updateMap

$ ->
  do initialize
