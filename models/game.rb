class Game < Sequel::Model(:games)

  def self.all
    Game.where(:active => true)
  end

  def self.retrieve_by_id(id)
    Game.where(:id => id)
  end

end