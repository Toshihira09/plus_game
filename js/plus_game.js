// Generated by CoffeeScript 1.12.7
(function() {
  $(function() {
    return app.initialize();
  });

  window.app = {
    width_tile: 0,
    height_tile: 0,
    theme_number: 0,
    sum_number: 0,
    point: 0,
    initial_count: 0,
    count: 0,
    click_count: 0,
    timer: false,
    click_number: 0,
    next_stage_number: 0,
    NEXT_STAGE_NUMBER: 20,
    round: 0,
    initialize: function() {
      this.hideSelecter('#setting');
      return this.setBind();
    },
    hideSelecter: function(selecter) {
      return $(selecter).css({
        'display': 'none'
      });
    },
    showSelecter: function(selecter) {
      return $(selecter).css({
        'display': 'block'
      });
    },
    setBind: function() {
      var self;
      self = this;
      $('#start').bind('click', function() {
        self.showSelecter('#setting');
        return self.hideSelecter('.start_screen');
      });
      $('#play_game').bind('click', function() {
        return self.getParameter();
      });
      $('#tile_area').on('click', '.play_number', function() {
        return self.choiceNumber(this);
      });
      return $('#reset').bind('click', function() {
        self.showSelecter('#setting');
        self.hideSelecter('#reset');
        return self.hideSelecter('#play_area');
      });
    },
    getParameter: function() {
      var height, width;
      width = width_setting.width_number.value;
      height = height_setting.height_number.value;
      this.width_tile = Number(width);
      this.height_tile = Number(height);
      if (width === "" || height === "") {
        return $('#caution').html("5~10の間の数字を入力してください！！");
      } else if (width < 5 || height < 5) {
        return $('#caution').html("5~10の間の数字を入力してください！！");
      } else if (width > 10 || height > 10) {
        return $('#caution').html("5~10の間の数字を入力してください！！");
      } else {
        $('#tile_area').empty();
        this.setParameter(1, 10, 50);
        return this.startGame();
      }
    },
    setParameter: function(round, initial_count, point) {
      this.round = round;
      this.initial_count = initial_count;
      this.count = initial_count;
      this.point = point;
      this.click_count = this.width_tile * this.height_tile;
      this.sum_number = 0;
      return this.hideSelecter('#setting');
    },
    startGame: function() {
      this.increaseHeightTile();
      this.showSelecter('#play_area');
      this.showSelecter('.before_game');
      $('#round').html(this.round);
      $('.play_number').css({
        'pointer-events': 'auto'
      });
      this.showThemeNumber();
      this.hideSelecter('.to_next_game');
      return this.hideSelecter('#setting');
    },
    showThemeNumber: function() {
      this.stopCountTime();
      this.startCountTime();
      this.click_number = 0;
      this.sum_number = 0;
      this.theme_number = _.random(1, 19);
      $('#theme_number_area').html(this.theme_number);
      return $('#point').html(this.point);
    },
    increaseHeightTile: function() {
      var i, j, ref, results;
      results = [];
      for (i = j = 0, ref = this.height_tile; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        $('#tile_area').append("<tr id=\"height" + (i + 1) + "\"></tr>");
        results.push(this.increaseWidthTile("#height" + (i + 1)));
      }
      return results;
    },
    increaseWidthTile: function(selecter) {
      var i, j, number_tile, ref, results;
      results = [];
      for (i = j = 0, ref = this.width_tile; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        number_tile = _.random(1, 9);
        $(selecter).append("<td class= \"width" + (i + 1) + " play_number\" data-number=\"" + number_tile + "\"></td>");
        results.push($(selecter + " .width" + (i + 1)).html(number_tile));
      }
      return results;
    },
    choiceNumber: function(selecter) {
      var choice_number;
      choice_number = $(selecter).data('number');
      if ($(selecter).hasClass('unusable')) {
        $(selecter).removeClass('unusable');
        this.click_count += 1;
        this.sum_number -= choice_number;
        return this.click_number -= 1;
      } else {
        $(selecter).addClass('unusable');
        this.click_count -= 1;
        this.sum_number += choice_number;
        this.click_number += 1;
        return this.calculationResult();
      }
    },
    calculationResult: function() {
      if (this.sum_number === this.theme_number) {
        this.showResult('wrong_answer', 'correct_answer', "good");
        this.disableTile('.unusable');
        this.point += this.click_number * 10;
        this.count = this.initial_count;
        this.showThemeNumber();
        return this.toNextGame();
      } else if (this.sum_number > this.theme_number) {
        this.showResult('correct_answer', 'wrong_answer', "bad");
        this.disableTile('.unusable');
        this.point -= 10;
        this.count = this.initial_count;
        this.showThemeNumber();
        this.showGameResult(this.point, 0, "GameOver");
        return this.toNextGame();
      }
    },
    toNextGame: function() {
      if (this.click_count <= this.NEXT_STAGE_NUMBER) {
        this.round += 1;
        return this.changeStage();
      }
    },
    showResult: function(remove, add, result) {
      this.showSelecter('#answer_area');
      $('#answer_area').removeClass(remove);
      $('#answer_area').addClass(add);
      return $('#answer_area').html(result);
    },
    disableTile: function(selecter) {
      $(selecter).css({
        'background-color': 'black'
      });
      return $(selecter).css({
        'pointer-events': 'none'
      });
    },
    startCountTime: function() {
      var self;
      self = this;
      $('#count').html(self.count);
      return this.timer = setTimeout(function() {
        self.count -= 1;
        if (self.count === 0) {
          $('#count').html(self.count);
          self.showSelecter('.to_next_game');
          return self.showGameResult(self.count, 0, "GameOver");
        } else {
          return self.startCountTime();
        }
      }, 1000);
    },
    stopCountTime: function() {
      return clearTimeout(this.timer);
    },
    showGameResult: function(selecter, number, result) {
      if (selecter === number) {
        this.stopCountTime();
        this.disableTile('.play_number');
        this.showSelecter('#reset');
        this.showSelecter('#game_result');
        $('#game_result').html(result);
        return $('#reset').html("<img src=\"./image/reset.png\">");
      }
    },
    changeStage: function() {
      $('.play_number').removeClass('unusable');
      $('#tile_area').empty();
      this.hideSelecter('#reset');
      this.hideSelecter('#game_result');
      if (this.count === 0 || this.point === 0) {
        this.resetStage();
      }
      if (this.round > 1) {
        return this.changeNextStage();
      }
    },
    resetStage: function() {
      this.setParameter(1, 10, 50);
      return this.startGame();
    },
    changeNextStage: function() {
      this.setParameter(this.round, this.initial_count - 1, this.point);
      this.height_tile += 1;
      this.width_tile += 1;
      this.startGame();
      return this.showGameResult(this.round, 3, "Excellent");
    }
  };

}).call(this);
