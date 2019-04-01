$ ->
  app.initialize()

window.app =
  number_tile: 0
  width_tile: 0
  height_tile: 0
  height_tile_name: 0
  initialize:->
    @setBind()
    @increaseHeigtTile()

  setBind: ->
    $('#choki').bind 'click', =>


  showHeightNumber: ->
    @number_tile = _.random 0, 9
    $("#number#{@height_tile_name}").html @number_tile

  increaseHeigtTile: ->
    @height_tile = 10
    @height_tile_name = 0
    for i in [0...@height_tile]
      @height_tile_name += 1
      $('#height_tile').append """<div id="number#{@height_tile_name}"></div>"""
      @showHeightNumber()
