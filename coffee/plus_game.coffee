$ ->
  app.initialize()

window.app =
  number_tile: 0
  width_tile: 0
  height_tile: 0
  width_tile_name: 0
  height_tile_name: 0
  theme_number: 0
  sum_number: 0
  choice_number: 0
  point: 0
  count: 0
  click_count: 0
  timer: false
  click_number: 0
  next_stage_number: 0
  round: 0
  initialize:->
    @width_tile = 5
    @height_tile = 5
    @round = 0
    @point = 50
    @increaseHeightTile()
    @choiceParameter()
    @hideElement()
    @setBind()
    @showPoint()

  hideSelecter:(selecter) ->
    $(selecter).css 'display':'none'

  showSelecter:(selecter) ->
    $(selecter).css 'display':'block'

  hideElement: ->
    $('#start').html """<img src="./image/start.png">"""
    @hideSelecter '#tile_area'
    @hideSelecter '#round'
    @hideSelecter '#count_area'
    @hideSelecter '#theme_number'
    @hideSelecter '#answer_area'
    @hideSelecter '#point_area'
    @hideSelecter '#point'
    @hideSelecter '#game_result'
    @hideSelecter '#reset'

  choiceParameter: ->
    @round += 1
    $('#round').html @round
    @click_count = @width_tile * @height_tile
    @sum_number = 0
    @next_stage_number = 20

  showPoint: ->
    $('#point').html @point

  showThemeNumber: ->
    @stopCountTime()
    @count = 10
    @click_number = 0
    @sum_number = 0
    @theme_number = _.random 1,19
    @startCountTime()
    $('#theme_number_area').html @theme_number

  increaseWidthTile:(selecter) ->
    for i in [0...@width_tile]
      @width_tile_name += 1
      number_tile = _.random 1, 9
      $(selecter).append """<td id="width#{@width_tile_name}" class= "play_number" data-number="#{number_tile}"></td>"""
      $(selecter).data 'number', 'number_tile'
      $("#width#{@width_tile_name}").html number_tile

  increaseHeightTile: ->
    for i in [0...@height_tile]
      @height_tile_name += 1
      $('#tile_area').append """<tr id="height#{@height_tile_name}"></tr>"""
      @increaseWidthTile "#height#{@height_tile_name}"

  setBind: ->
    self = @
    $('#start').bind 'click', ->
      self.startGame()
    $('.play_number').bind 'click', ->
      self.choiceNumber @
    $('#reset').bind 'click', ->
      self.changeNextGame()

  startGame: ->
    @hideSelecter '#start'
    @showSelecter '#round'
    @showSelecter '#tile_area'
    @showSelecter '#count_area'
    @showSelecter '#theme_number'
    @showSelecter '#answer_area'
    @showSelecter '#point_area'
    @showSelecter '#point'
    @showSelecter '#game_result'
    @showThemeNumber()

  choiceNumber:(selecter) ->
    if $(selecter).hasClass('unusable')
      $(selecter).removeClass 'unusable'
      @choice_number = $(selecter).data 'number'
      @sum_number -= @choice_number
      $(selecter).css 'background-color':'white'
    else
      @choice_number = $(selecter).data 'number'
      @click_count -= 1
      @sum_number = @sum_number + @choice_number
      @click_number += 1
      $(selecter).addClass 'unusable'
      @calculationResult selecter

  calculationResult:(selecter) ->
    if @sum_number is @theme_number
        $('#answer_area').addClass 'correct_answer'
        $('#answer_area').html "good"
        @disableTile '.unusable'
        @point += @click_number * 10
        @showPoint()
        @showThemeNumber()
        if @click_count <= @next_stage_number
          @changeNextGame()
     else if @sum_number > @theme_number
        $('#answer_area').addClass 'wrong_answer'
        $('#answer_area').html "bad"
        @disableTile '.unusable'
        @point -= 10
        @showPoint()
        @showThemeNumber()
        @showGameResult @point
        if @click_count <= @next_stage_number
          @changeNextGame()
     else
        $(selecter).css 'background-color':'gray'

  disableTile:(selecter) ->
    $(selecter).css 'background-color':'black'
    $(selecter).css 'pointer-events':'none'

  startCountTime: ->
    self = @
    $('#count').html self.count
    @timer = setTimeout ->
      self.count -= 1
      if self.count is 0
        $('#count').html self.count
        self.disableTile '.unusable'
        self.showGameResult self.count
      else
        self.startCountTime()
    ,1000

  stopCountTime: ->
    clearTimeout @timer

  showGameResult:(selecter) ->
    if selecter is 0
      @stopCountTime()
      @disableTile '.play_number'
      @showSelecter '#reset'
      @showSelecter '#game_result'
      $('#game_result').html "GameOver"
      $('#reset').html """<img src="./image/reset.png">"""

  changeNextGame: ->
    $('.play_number').removeClass 'unusable'
    $('#tile_area').empty()
    $('.play_number').html ''
    @height_tile += 1
    @width_tile += 1
    @choiceParameter()
    @inputNumber()
    @increaseHeightTile()
    $('.play_number').css 'background-color':'white'
    $('.play_number').css 'pointer-events':'auto'
    @showThemeNumber()
    @hideSelecter '#reset'
    @hideSelecter '#game_result'
    @setBind()

  inputNumber: ->
    @width_tile_name = 0
    console.log @click_count
    for i in [0...@click_count]
      @width_tile_name += 1
      number_tile = _.random 1, 9
      $("#width#{@width_tile_name}").html number_tile
      $("#width#{@width_tile_name}").data 'number', number_tile
