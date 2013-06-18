class SeasonGame < Sequel::Model(:seasongames)

  def self.insert_season_game_assoc(season_id, game_id)
    SeasonGame.insert(:season_id => season_id, :game_id => game_id)
  end

end