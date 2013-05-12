class Game < Sequel::Model(:games)

  def self.all
    Game.where(:active => true)
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