class Team < Sequel::Model(:teams)
  one_to_many :seasons
  one_to_many :games

  #### SCHEMA
  #primary_key :id
  #String :name
  #String :stadium
  #String :city
  #String :state
  #DateTime :last_updated
  #DateTime :created
  #Boolean :active

  def self.active_teams
    Team.where(:active => true)
  end

  def self.insert_new(name, stadium, city, state)
    Team.insert(:name => name, :stadium => stadium, :city => city, :state => state, :last_updated => Time.new, :created => Time.new, :active => true)
  end

end