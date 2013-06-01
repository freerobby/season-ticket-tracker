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

  $.getJSON("/games/", function(raw) {
      self.isLoadingOrError(true);
      var games = $.map(raw, function(item) { return new Game(item) });
      self.games(games);
      $('#game-list-info').html("");
  })
  .done(function () { self.isLoadingOrError(false); })
  .fail(function () { $('#game-list-info').html("Error loading the game list."); });

  self.typeToShow = ko.observable("all");

  self.filterGames = function(data, event, type) {
      self.typeToShow(type);
  }

  self.gamesToShow = ko.computed(function() {
      var desiredType = this.typeToShow();

      if (desiredType == "all") return this.games();

      return ko.utils.arrayFilter(this.games(), function(game) {
          if (desiredType == "day")
          {
            return game.is_day_game;
          } else if (desiredType == "afternoon") {
            return game.is_afternoon_game;
          } else if (desiredType == "night") {
            return game.is_night_game;
          } else if (desiredType == "weekend") {
            return game.is_weekend_game;
          } else if (desiredType == "weekday") {
            return game.is_weekday_game;
          }
      });
  }, self);
}

$(document).ready(function(){
  ko.applyBindings(new GameViewModel());
});
