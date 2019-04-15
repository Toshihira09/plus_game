$ ->
  app.initialize()

window.app =
  width_tile: 0
  height_tile: 0
  theme_number: 0
  sum_number: 0
  point: 0
  initial_count: 0
  count: 0
  click_count: 0
  timer: false
  click_number: 0
  next_stage_number: 0
  NEXT_STAGE_NUMBER: 20
  round: 0
  initialize:->
    @hideSelecter '#setting'
    @setBind()

  hideSelecter:(selecter) ->
    $(selecter).css 'display':'none'

  showSelecter:(selecter) ->
    $(selecter).css 'display':'block'

  setBind: ->
    self = @
    $('#start').bind 'click', ->
      self.showSelecter '#setting'
      self.hideSelecter '#start'
    $('#play_game').bind 'click', ->
      self.getParameter()
    $('#tile_area').on 'click', '.play_number', ->
      self.choiceNumber @
    $('#reset').bind 'click', ->
      self.showSelecter '#setting'
      self.hideSelecter '#reset'
      self.hideSelecter '#play_area'

  getParameter : ->
    width = width_setting.width_number.value
    height = height_setting.height_number.value
    @width_tile = Number width
    @height_tile = Number height
    if width is "" or height is ""
      $('#caution').html "5~10の間の数字を入力してください！！"
    else if width < 5 or height < 5
      $('#caution').html "5~10の間の数字を入力してください！！"
    else if width > 10 or height > 10
      $('#caution').html "5~10の間の数字を入力してください！！"
    else
      $('#tile_area').empty()
      @setParameter(1, 10, 50)
      @startGame()

  setParameter:(round, initial_count, point) ->
    @round = round
    @initial_count = initial_count
    @count = initial_count
    @point = point
    @click_count = @width_tile * @height_tile
    @sum_number = 0
    @hideSelecter '#setting'

  startGame: ->
    @increaseHeightTile()
    @showSelecter '#play_area'
    @showSelecter '.before_game'
    $('#round').html @round
    $('.play_number').css 'pointer-events':'auto'
    @showThemeNumber()
    @hideSelecter '.to_next_game'
    @hideSelecter '#setting'

  showThemeNumber: ->
    @stopCountTime()
    @startCountTime()
    @click_number = 0
    @sum_number = 0
    @theme_number = _.random 1,19
    $('#theme_number_area').html @theme_number
    $('#point').html @point

  increaseHeightTile: ->
    for i in [0...@height_tile]
      $('#tile_area').append """<tr id="height#{i + 1}"></tr>"""
      @increaseWidthTile "#height#{i + 1}"

  increaseWidthTile:(selecter) ->
    for i in [0...@width_tile]
      number_tile = _.random 1, 9
      $(selecter).append """<td class= "width#{i + 1} play_number" data-number="#{number_tile}"></td>"""
      $("#{selecter} .width#{i + 1}").html number_tile

  choiceNumber:(selecter) ->
    choice_number = $(selecter).data 'number'
    if $(selecter).hasClass('unusable')
      $(selecter).removeClass 'unusable'
      @click_count += 1
      @sum_number -= choice_number
      @click_number -= 1
    else
      $(selecter).addClass 'unusable'
      @click_count -= 1
      @sum_number += choice_number
      @click_number += 1
      @calculationResult()

  calculationResult: ->
    if @sum_number is @theme_number
        @showResult 'wrong_answer', 'correct_answer', "good"
        @disableTile '.unusable'
        @point += @click_number * 10
        @count = @initial_count
        @showThemeNumber()
        @toNextGame()
     else if @sum_number > @theme_number
        @showResult 'correct_answer', 'wrong_answer' , "bad"
        @disableTile '.unusable'
        @point -= 10
        @count = @initial_count
        @showThemeNumber()
        @showGameResult @point, 0, "GameOver"
        @toNextGame()

  toNextGame: ->
    if @click_count <= @NEXT_STAGE_NUMBER
      @round += 1
      @changeStage()

  showResult:(remove, add, result) ->
    @showSelecter '#answer_area'
    $('#answer_area').removeClass remove
    $('#answer_area').addClass add
    $('#answer_area').html result

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
    if @count is 0 or @point is 0
      @resetStage()
    if @round > 1
      @changeNextStage()

  resetStage: ->
    @setParameter(1, 10, 50)
    @startGame()

  changeNextStage: ->
    @setParameter(@round, @initial_count - 1, @point)
    @height_tile += 1
    @width_tile += 1
    @startGame()
    @showGameResult @round, 3, "Excellent"
