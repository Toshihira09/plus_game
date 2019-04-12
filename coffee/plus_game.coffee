$ ->
  app.initialize()

window.app =
  width_tile: 0
  height_tile: 0
  width_tile_name: 0
  height_tile_name: 0
  theme_number: 0
  sum_number: 0
  point: 0
  initial_count: 0
  count: 0
  click_count: 0
  timer: false
  click_number: 0
  next_stage_number: 0
  round: 0
  initialize:->
    @choiceParameter()
    @increaseHeightTile()
    @hideElement()
    @setBind()

  choiceParameter: ->
    @width_tile = 5
    @height_tile = 5
    @click_count = @width_tile * @height_tile
    @sum_number = 0
    @next_stage_number = 20

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

  hideElement: ->
    @hideSelecter '.before_game'
    $('#start').html """<img src="./image/start.png">"""

  hideSelecter:(selecter) ->
    $(selecter).css 'display':'none'

  showSelecter:(selecter) ->
    $(selecter).css 'display':'block'

  showThemeNumber: ->
    @stopCountTime()
    @click_number = 0
    @sum_number = 0
    @theme_number = _.random 1,19
    $('#theme_number_area').html @theme_number

  setBind: ->
    self = @
    $('#start').bind 'click', ->
      self.startGame()
    $('.play_number').bind 'click', ->
      self.choiceNumber @
    $('#reset').bind 'click', ->
      self.changeStage()

  startGame: ->
    @round = 1
    $('#round').html @round
    @point = 50
    $('#point').html @point
    @hideSelecter '#start'
    @showSelecter '.before_game'
    $('#round').css 'display':'inline'
    @showThemeNumber()
    @initial_count = 10
    @count = @initial_count
    @startCountTime()

  choiceNumber:(selecter) ->
    if $(selecter).hasClass('unusable')
      $(selecter).removeClass 'unusable'
      @sum_number -= choice_number
      $(selecter).css 'background-color':'white'
    else
      choice_number = $(selecter).data 'number'
      @click_count -= 1
      @sum_number = @sum_number + choice_number
      @click_number += 1
      $(selecter).addClass 'unusable'
      $(selecter).css 'background-color':'gray'
      @calculationResult()

  calculationResult: ->
    if @sum_number is @theme_number
        @showSelecter '#answer_area'
        $('#answer_area').removeClass 'wrong_answer'
        $('#answer_area').addClass 'correct_answer'
        $('#answer_area').html "good"
        @disableTile '.unusable'
        $('.unusable').css 'pointer-events':'none'
        @point += @click_number * 10
        $('#point').html @point
        @showThemeNumber()
        @count = @initial_count
        @startCountTime()
        @showGameResult @round, 3, "Excellent"
        if @click_count <= @next_stage_number
          @round += 1
          @changeStage()
     else if @sum_number > @theme_number
        @showSelecter '#answer_area'
        $('#answer_area').removeClass 'correct_answer'
        $('#answer_area').addClass 'wrong_answer'
        $('#answer_area').html "bad"
        @disableTile '.unusable'
        $('.unusable').css 'pointer-events':'none'
        @point -= 10
        $('#point').html @point
        @showThemeNumber()
        @count = @initial_count
        @startCountTime()
        @showGameResult @point, 0, "GameOver"
        if @click_count <= @next_stage_number
          @round += 1
          @changeStage()

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
        #self.disableTile '.unusable'
        self.showSelecter '.to_next_game'
        self.showGameResult self.count, 0, "GameOver"
      else
        self.startCountTime()
    ,1000

  stopCountTime: ->
    clearTimeout @timer

  showGameResult:(selecter, number, result) ->
    if selecter is number
      @stopCountTime()
      @disableTile '.play_number'
      @showSelecter '#reset'
      @showSelecter '#game_result'
      $('#game_result').html result
      $('#reset').html """<img src="./image/reset.png">"""

  changeStage: ->
    $('.play_number').removeClass 'unusable'
    $('#tile_area').empty()
    @hideSelecter '#reset'
    @hideSelecter '#game_result'
    $('#reset').unbind 'click'
    if @count is 0 or @point is 0
      @resetStage()
    if @round > 1
      @changeNextStage()

  resetStage: ->
    @choiceParameter()
    @round = 1
    @startGame()
    @hideSelecter '.to_next_game'
    $('.play_number').css 'pointer-events':'auto'
    @increaseHeightTile()
    @setBind()

  changeNextStage: ->
    @choiceParameter()
    @height_tile += 1
    @width_tile += 1
    @initial_count -= 1
    @count = @initial_count
    $('.play_number').css 'pointer-events':'auto'
    @increaseHeightTile()
    @showThemeNumber()
    @startCountTime()
    @setBind()
    $('#round').html @round
