class Season < Sequel::Model(:seasons)
  many_to_one :teams

  #### SCHEMA
  #primary_key :id
  #foreign_key :team_id, :teams
  #Integer :year
  #DateTime :last_updated
  #DateTime :created
  #Boolean :active

  def self.active_seasons(team_id)
    Season.where(:active => true, :team_id => team_id)
  end

  def self.insert_new(team_id, year)
    Season.insert(:team_id => team_id, :year => year, :last_updated => Time.new, :created => Time.new, :active => true)
  end

end