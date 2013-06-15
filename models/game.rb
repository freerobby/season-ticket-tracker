class Game < Sequel::Model(:games)

  def self.all
    Game.order(:date_time)
  end

  def self.active_games
    Game.where(:active => true).order(:date_time)
  end

  def self.inactive_games
    Game.where(:active => false)
  end

  def self.set_game_active_status(id, status)
    Game.where(:id => id).update(:active => status, :last_updated => Time.new)
  end

  def self.retrieve_by_id(id)
    Game.where(:id => id)
  end

  def self.insert_new(opponent, stadium, description, date_time)
    Game.insert(:opponent => opponent, :stadium => stadium, :description => description, :date_time => date_time, :last_updated => Time.new, :active => true)
  end

  def self.clear
    Game.delete
  end

end