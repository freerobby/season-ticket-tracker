class Game

  include DataMapper::Resource

  property :id,           Serial
  property :opponent,     String
  property :location,     String
  property :description,  Text
  property :gametime,     DateTime
  property :created_at,   DateTime

  has n, :season_games
  has n, :seasons,      :through => :season_games

end