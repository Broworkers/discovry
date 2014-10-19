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
    center: new google.maps.LatLng(-34.397, 150.644)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    zoom: 8

  map = new google.maps.Map(elem, mapOptions)
  geocoder = new google.maps.Geocoder()

  google.maps.event.addListener map, 'dragend', ->
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
        $('div.content').html(data)

      jQuery.get('/', place: address, update)


$ ->
  do initialize
