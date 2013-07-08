function GameViewModel(gameURL) {
  var self = this;

  self.gameURL = gameURL;
  self.game = ko.observable(new Game())

  self.loadData = function() {
    $.getJSON(self.gameURL, function(raw) {
        self.game(new Game(raw));
    });
  }

  self.toggleActiveStatus = function() {
    var currValue = self.game().active();

    self.game().active(!currValue);

    var activeStatus = self.game().active() ? "active" : "inactive";

    $.post("/game/" + self.game().game_id + "/set/" + activeStatus)
    .fail(function (){
      // TODO: throw status that the action didn't save

      //reset back to previous value
      self.game().active(currValue);
    })
  }

  self.toggleUsedStatus = function() {
    var currValue = self.game().used();

    self.game().used(!currValue);

    var usedStatus = self.game().used() ? "used" : "unused";

    $.post("/game/" + self.game().game_id + "/set/used/" + usedStatus)
    .fail(function (){
      // TODO: throw status that the action didn't save

      //reset back to previous value
      self.game().used(currValue);
    })
  }

  self.toggleSoldStatus = function() {
    var currValue = self.game().sold();

    self.game().sold(!currValue);

    var soldStatus = self.game().sold() ? "sold" : "unsold";

    $.post("/game/" + self.game().game_id + "/set/sold/" + soldStatus)
    .fail(function (){
      // TODO: throw status that the action didn't save

      //reset back to previous value
      self.game().sold(currValue);
    })
  }
}
