class Season

  include DataMapper::Resource

  property :id,         Serial
  property :year,       Integer
  property :created_at, DateTime

  belongs_to :team
  
  has n, :season_games
  has n, :games,      :through => :season_games

end