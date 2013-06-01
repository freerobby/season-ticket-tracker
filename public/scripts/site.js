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

  // helper text
  self.game_time_text = self.is_day_game ? " (Day)" : self.is_afternoon_game ? " (Afternoon)" : " (Night)";

  // expected time from server is EDT
  self.time_of_day = moment(self.datetime).subtract("hours", 1).format("hh:mm A") + " CDT";
  self.date = self.datetime.format("MMMM DD");
}

function GameViewModel() {
  var self = this;
  self.games = ko.observableArray([]);
  $.getJSON("/games", function(raw) {
      var games = $.map(raw, function(item) { return new Game(item) });
      self.games(games);
  });

  self.filterGames = function(data, event, type) {
    if (type == "all")
      self.typeToShow("all");
    else if (type == "night")
      self.typeToShow("night");
    else if (type == "afternoon")
    self.typeToShow("afternoon");
  }

  self.typeToShow = ko.observable("all");

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
          }
      });
  }, self);
}

$(document).ready(function(){
  ko.applyBindings(new GameViewModel());
});
