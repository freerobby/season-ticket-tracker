function Game(data) {
  var self = this;
  self.datetime = moment(data.date_time, "YYYY-MM-DD HH:mm:ss ZZ");
  self.opponent = data.opponent;
  self.id = data.id;
  self.day_of_week = self.datetime.format("dddd");

  // helper properties
  self.is_day_game = self.datetime.hour() < 15;
  self.is_afternoon_game = self.datetime.hour() > 14 && self.datetime.hour() < 17;
  self.is_night_game = self.datetime.hour() > 16;
  self.is_weekend_game = self.datetime.day() == 0 || self.datetime.day() == 6;
  self.is_weekday_game = self.datetime.day() > 0 && self.datetime.day() < 6;

  // helper text
  self.game_time_text = self.is_day_game ? " (Day)" : self.is_afternoon_game ? " (Afternoon)" : " (Night)";

  // expected time from server is EDT
  self.time_of_day = moment(self.datetime).subtract("hours", 1).format("hh:mm A") + " CDT";
  self.date = self.datetime.format("MMMM DD");
}

function GameViewModel() {
  var self = this;

  self.games = ko.observableArray([]);

  self.isLoadingOrError = ko.observable(true);

  self.isAllGameFilterSet = ko.observable(true);
  self.isNightGameFilterSet = ko.observable(false);
  self.isDayGameFilterSet = ko.observable(false);
  self.isAfternoonGameFilterSet = ko.observable(false);
  self.isWeekendGameFilterSet = ko.observable(false);
  self.isWeekdayGameFilterSet = ko.observable(false);

  self.toggleIsAllGameFilter = function () {
    self.isAllGameFilterSet(!self.isAllGameFilterSet());
    self.isNightGameFilterSet(false);
    self.isDayGameFilterSet(false);
    self.isWeekdayGameFilterSet(false);
    self.isWeekendGameFilterSet(false);
    self.isAfternoonGameFilterSet(false);
  };

  self.toggleIsNightGameFilter = function () {
    self.isNightGameFilterSet(!self.isNightGameFilterSet())
    self.isAllGameFilterSet(false);
    self.isDayGameFilterSet(false);
    self.isWeekdayGameFilterSet(false);
    self.isWeekendGameFilterSet(false);
    self.isAfternoonGameFilterSet(false);
  };

  self.toggleIsDayGameFilter = function () {
    self.isDayGameFilterSet(!self.isDayGameFilterSet());
    self.isAllGameFilterSet(false);
    self.isNightGameFilterSet(false);
    self.isWeekdayGameFilterSet(false);
    self.isWeekendGameFilterSet(false);
    self.isAfternoonGameFilterSet(false);
  };

  self.toggleIsAfternoonGameFilter = function () {
    self.isAfternoonGameFilterSet(!self.isAfternoonGameFilterSet());
    self.isAllGameFilterSet(false);
    self.isNightGameFilterSet(false);
    self.isDayGameFilterSet(false);
    self.isWeekdayGameFilterSet(false);
    self.isWeekendGameFilterSet(false);
  };

  self.toggleIsWeekendGameFilter = function () {
    self.isWeekendGameFilterSet(!self.isWeekendGameFilterSet());
    self.isAllGameFilterSet(false);
    self.isNightGameFilterSet(false);
    self.isDayGameFilterSet(false);
    self.isWeekdayGameFilterSet(false);
    self.isAfternoonGameFilterSet(false);
  };

  self.toggleIsWeekdayGameFilter = function () {
    self.isWeekdayGameFilterSet(!self.isWeekdayGameFilterSet());
    self.isAllGameFilterSet(false);
    self.isNightGameFilterSet(false);
    self.isDayGameFilterSet(false);
    self.isWeekendGameFilterSet(false);
    self.isAfternoonGameFilterSet(false);
  };

  self.loadData = function() {
    self.isLoadingOrError(true);

    $.getJSON("/games/", function(raw) {
        var games = $.map(raw, function(item) { return new Game(item) });
        self.games(games);
        $('#game-list-info').html("");
    })
    .done(function () { self.isLoadingOrError(false); })
    .fail(function () { $('#game-list-info').html("Error loading the game list."); });
  }

  self.gamesToShow = ko.computed(function() {
      if (self.isAllGameFilterSet())
      {
        return this.games();
      }

      return ko.utils.arrayFilter(this.games(), function(game) {
          if (self.isDayGameFilterSet())
          {
            return game.is_day_game;
          } else if (self.isAfternoonGameFilterSet()) {
            return game.is_afternoon_game;
          } else if (self.isNightGameFilterSet()) {
            return game.is_night_game;
          } else if (self.isWeekendGameFilterSet()) {
            return game.is_weekend_game;
          } else if (self.isWeekdayGameFilterSet()) {
            return game.is_weekday_game;
          }
      });
  }, self);
}

$(document).ready(function(){
  var gameView = new GameViewModel();
  ko.applyBindings(gameView);
  gameView.loadData();

});
