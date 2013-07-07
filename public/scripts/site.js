function Season(data) {
  var self = this;

  self.id = data.id;
  self.year = data.year;
  self.created_at = data.created_at;

  self.games = $.map(data.games, function(item) { return new Game(item) });
}

function Game(data) {
  var self = this;
  self.datetime = moment(data.gametime, "YYYY-MM-DD HH:mm:ss ZZ");
  self.opponent = data.opponent;
  self.game_id = data.id;
  self.day_of_week = self.datetime.format("dddd");
  self.active = ko.observable(data.active ? true : false);
  self.sold = ko.observable(data.sold ? true : false);
  self.used = ko.observable(data.used ? true : false);

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

function ViewModel(gamesURL) {
  var self = this;

  self.gamesURL = gamesURL;

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

    $.getJSON(self.gamesURL, function(raw) {
        //var seasons = $.map(raw, function(item) { return new Season(item) });
        //self.games(seasons[0].games);

        var games = $.map(raw, function(item) { return new Game(item) });
        self.games(games);
    })
    .done(function () {
      if (self.games().length == 0)
      {
        $('#game-list-info').html("No games were found.");
      } else {
        $('#game-list-info').html("");
        self.isLoadingOrError(false);
      }

    })
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

  self.numGamesText = ko.computed(function() {
    return self.gamesToShow().length + " Games";
  }, self);

  self.activeGamesText = ko.computed(function() {
    var activeGames = ko.utils.arrayFilter(self.games(), function(item)
    {
        return item.active();
    });

    return "Active Games: " + activeGames.length;
  });

  self.activeDayGamesCountText = ko.computed(function() {
    var activeGames = ko.utils.arrayFilter(self.games(), function(item)
    {
        return item.active() && item.is_day_game;
    });

    return "Active Day Games: " + activeGames.length;
  });

  self.activeAfternoonGamesCountText = ko.computed(function() {
    var activeGames = ko.utils.arrayFilter(self.games(), function(item)
    {
        return item.active() && item.is_afternoon_game;
    });

    return "Active Afternoon Games: " + activeGames.length;
  });

  self.activeNightGamesCountText = ko.computed(function() {
    var activeGames = ko.utils.arrayFilter(self.games(), function(item)
    {
        return item.active() && item.is_night_game;
    });

    return "Active Night Games: " + activeGames.length;
  });

  self.toggleActiveStatus = function(game) {
    var currValue = game.active();

    game.active(!currValue);

    var activeStatus = game.active() ? "active" : "inactive";

    $.post("/game/" + game.game_id + "/set/" + activeStatus)
    .fail(function (){
      // TODO: throw status that the action didn't save

      //reset back to previous value
      game.active(currValue);
    })
  }

  self.toggleUsedStatus = function(game) {
    var currValue = game.used();

    game.used(!currValue);

    var usedStatus = game.used() ? "used" : "unused";

    $.post("/game/" + game.game_id + "/set/used/" + usedStatus)
    .fail(function (){
      // TODO: throw status that the action didn't save

      //reset back to previous value
      game.used(currValue);
    })
  }

  self.toggleSoldStatus = function(game) {
    var currValue = game.sold();

    game.sold(!currValue);

    var soldStatus = game.sold() ? "sold" : "unsold";

    $.post("/game/" + game.game_id + "/set/sold/" + soldStatus)
    .fail(function (){
      // TODO: throw status that the action didn't save

      //reset back to previous value
      game.sold(currValue);
    })
  }
}
