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
    center = map.getCenter()
    zoom = map.getZoom()

    [lat, lng] = [center.lat(), center.lng()]

    jQuery.ajax
      url: '/'
      success: update
      data:
        format: 'json'
        zoom: zoom
        lat: lat
        lng: lng

  setTimeout updateMap, 500

  google.maps.event.addListener map, 'dragend', updateMap
  google.maps.event.addListener map, 'zoom_changed', updateMap

  update = (data) ->
    renderWikipedia(data)

  renderFlickr = (data) ->
    photos = data.photos

    $('.photos').html('')

    for photo in photos
      a = $('<a>').attr
        target: '_blank'
        href: photo.url
        target: '_blank'
        style: "background-image: url(#{photo.thumb})"
      li = $('<li>').append a

      $('.photos').append(li)


  renderWikipedia = (data) ->
    renderFlickr(data)
    if data.wikipedia.summary isnt null
      $('.summary').text(data.wikipedia.summary)
      link = $('<a>').attr(href: data.wikipedia.url, target: '_blank').text(data.wikipedia.title)
      $('.title').html(link)

$(initialize)
